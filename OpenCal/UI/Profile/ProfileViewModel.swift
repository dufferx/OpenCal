import Foundation
import Observation

@Observable final class ProfileViewModel {

    private let repository: UserProfileRepositoryProtocol

    private var profileId: UUID = UUID()
    var name: String = ""
    var profileImageData: Data? = nil
    var birthDate: Date = Calendar.current.date(byAdding: .year, value: -AppConstants.Defaults.ageOffset, to: Date()) ?? Date()
    var biologicalSex: BiologicalSex = .male
    var heightCm: String = ""
    var weightKg: String = ""
    var calorieGoal: String = ""
    var proteinGoal: String = ""
    var carbsGoal: String = ""
    var fatGoal: String = ""
    var fitnessGoal: FitnessGoal = .maintain
    var apiProvider: AIProvider = .openAI
    var apiKey: String = ""
    var showGoalPicker: Bool = false
    var isSaving: Bool = false
    var didSaveSuccessfully: Bool = false

    private var saveTask: Task<Void, Never>?

    init(repository: UserProfileRepositoryProtocol = UserProfileRepository()) {
        self.repository = repository
    }

    func loadProfile() async {
        async let profile = repository.loadProfile()
        async let imageData = repository.loadProfileImage()
        let (loadedProfile, loadedImage) = await (profile, imageData)
        await MainActor.run {
            if let loadedProfile {
                hydrate(from: loadedProfile)
            }
            self.profileImageData = loadedImage
            self.apiKey = KeychainHelper.load(for: AppConstants.Keychain.apiKeyIdentifier) ?? ""
        }
    }

    func hydrate(from profile: UserProfile) {
        profileId = profile.id
        name = profile.name
        birthDate = profile.birthDate
        biologicalSex = profile.biologicalSex
        heightCm = profile.heightCm > 0 ? String(profile.heightCm) : ""
        weightKg = profile.weightKg > 0 ? String(profile.weightKg) : ""
        calorieGoal = String(profile.dailyCalorieGoal)
        proteinGoal = String(profile.dailyProteinGoal)
        carbsGoal = String(profile.dailyCarbsGoal)
        fatGoal = String(profile.dailyFatGoal)
        apiProvider = profile.apiProvider
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
        && (Double(calorieGoal) ?? 0) > 0
    }

    func scheduleSave() {
        saveTask?.cancel()
        saveTask = Task {
            try? await Task.sleep(for: .seconds(0.6))
            guard !Task.isCancelled else { return }
            await save()
        }
    }

    func save() async {
        guard isValid else { return }
        await MainActor.run { isSaving = true }
        let profile = buildUserProfile()
        await repository.saveProfile(profile)
        if let imageData = profileImageData {
            await repository.saveProfileImage(imageData)
        }
        if apiKey.isEmpty {
            KeychainHelper.delete(for: AppConstants.Keychain.apiKeyIdentifier)
        } else {
            KeychainHelper.save(apiKey, for: AppConstants.Keychain.apiKeyIdentifier)
        }
        await MainActor.run {
            isSaving = false
            didSaveSuccessfully = true
            // Reset the success indicator after a moment
            Task {
                try? await Task.sleep(for: .seconds(2))
                if !Task.isCancelled {
                    didSaveSuccessfully = false
                }
            }
        }
    }

    func applyFitnessGoal(_ goal: FitnessGoal) {
        fitnessGoal = goal
        calorieGoal = goal.defaultCalories
        proteinGoal = goal.defaultProtein
        carbsGoal = goal.defaultCarbs
        fatGoal = goal.defaultFat
    }

    private func buildUserProfile() -> UserProfile {
        UserProfile(
            id: profileId,
            name: name.trimmingCharacters(in: .whitespaces),
            birthDate: birthDate,
            biologicalSex: biologicalSex,
            apiProvider: apiProvider,
            heightCm: Double(heightCm) ?? 0,
            weightKg: Double(weightKg) ?? 0,
            dailyCalorieGoal: Double(calorieGoal) ?? AppConstants.Defaults.dailyCalorieGoal,
            dailyProteinGoal: Double(proteinGoal) ?? AppConstants.Defaults.dailyProteinGoal,
            dailyCarbsGoal: Double(carbsGoal) ?? AppConstants.Defaults.dailyCarbsGoal,
            dailyFatGoal: Double(fatGoal) ?? AppConstants.Defaults.dailyFatGoal
        )
    }
}
