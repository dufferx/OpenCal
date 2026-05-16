import Foundation
import Observation

@Observable final class HomeViewModel {
    var selectedDate: Date = .now {
        didSet { Task { await loadLog() } }
    }
    var dailyLog: DailyLog = DailyLog(date: .now, entries: [])
    var userProfile: UserProfile = UserProfile.mock
    var profileImageData: Data? = nil
    var datesWithLogs: Set<DateComponents> = []
    var showManualEntry: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let repository: FoodRepositoryProtocol
    private let profileRepository: UserProfileRepositoryProtocol
    var appState: AppState?

    init(
        repository: FoodRepositoryProtocol = FoodRepository(),
        profileRepository: UserProfileRepositoryProtocol = UserProfileRepository(),
        appState: AppState? = nil
    ) {
        self.repository = repository
        self.profileRepository = profileRepository
        self.appState = appState

        Task { await loadLog() }
        reloadProfile()
    }

    func reloadProfile() {
        Task {
            async let profile = profileRepository.loadProfile()
            async let imageData = profileRepository.loadProfileImage()
            let (loadedProfile, loadedImage) = await (profile, imageData)
            await MainActor.run {
                if let loadedProfile { self.userProfile = loadedProfile }
                self.profileImageData = loadedImage
            }
        }
    }

    // MARK: - Repository actions

    func onTabBecameActive() {
        Task { await loadLog() }
    }

    func loadLog() async {
        await MainActor.run { isLoading = true }
        do {
            let log = try await repository.fetchLog(for: selectedDate)
            await MainActor.run {
                self.dailyLog = log
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func saveEntry(_ entry: FoodEntry) async {
        // Optimistic update — show immediately without waiting for persistence
        await MainActor.run {
            var updatedEntries = self.dailyLog.entries
            updatedEntries.append(entry)
            self.dailyLog = DailyLog(date: self.selectedDate, entries: updatedEntries)
            self.appState?.selectedTab = .home
        }
        // Persist and reload for consistency
        do {
            try await repository.saveEntry(entry, for: selectedDate)
            await loadLog()
        } catch {
            // Save failed — reload to revert the optimistic update
            await loadLog()
        }
    }

    func deleteEntry(id: UUID) async {
        do {
            try await repository.deleteEntry(id: id, for: selectedDate)
            await loadLog()
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Computed

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 0..<12: return "Good morning"
        case 12..<18: return "Good afternoon"
        default:     return "Good evening"
        }
    }

    var caloriesConsumed: Double {
        dailyLog.totalCalories
    }

    var calorieGoal: Double {
        userProfile.dailyCalorieGoal
    }
}
