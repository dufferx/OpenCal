import Foundation
import Combine

class OnboardingViewModel: ObservableObject {

    private let repository: UserProfileRepositoryProtocol

    init(repository: UserProfileRepositoryProtocol = UserProfileRepository()) {
        self.repository = repository
    }

    // Step 1 — Photo + Name
    @Published var profileImageData: Data? = nil
    @Published var name: String = ""

    // Step 2 — Biological Sex
    @Published var biologicalSex: BiologicalSex = .male

    // Step 3 — Date of Birth
    @Published var birthDate: Date = Calendar.current.date(
        byAdding: .year, value: -25, to: Date()) ?? Date()

    // Step 2 — Body (skippable)
    @Published var weightKg: String = ""
    @Published var heightCm: String = ""

    // Step 3 — Daily Goals
    @Published var calorieGoal: String = "2000"
    @Published var proteinGoal: String = "150"
    @Published var carbsGoal: String = "200"
    @Published var fatGoal: String = "65"
    @Published var fitnessGoal: FitnessGoal = .maintain
    @Published var showGoalPicker: Bool = false

    // Step 4 — API Key
    @Published var apiKey: String = ""
    @Published var apiProvider: AIProvider = .openAI

    // Step 5 — HealthKit (handled by HealthKit request — no stored state here)

    // Navigation
    @Published var currentStep: Int = 1
    let totalSteps: Int = 7

    // Validation
    var isStep1Valid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isStep3Valid: Bool {
        (Double(calorieGoal) ?? 0) > 0
    }

    func buildUserProfile() -> UserProfile {
        UserProfile(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            age: Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 25,
            heightCm: Double(heightCm) ?? 0,
            weightKg: Double(weightKg) ?? 0,
            dailyCalorieGoal: Double(calorieGoal) ?? 2000,
            dailyProteinGoal: Double(proteinGoal) ?? 150,
            dailyCarbsGoal: Double(carbsGoal) ?? 200,
            dailyFatGoal: Double(fatGoal) ?? 65
        )
    }

    func completeOnboarding() async {
        let profile = buildUserProfile()
        await repository.saveProfile(profile)
        if let imageData = profileImageData {
            await repository.saveProfileImage(imageData)
        }
    }

    func advance() {
        if currentStep <= totalSteps { currentStep += 1 }
    }

    func goBack() {
        if currentStep > 1 { currentStep -= 1 }
    }

    func skip() {
        advance()
    }
}
