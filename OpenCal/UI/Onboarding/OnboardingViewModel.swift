import Foundation
import Observation

@Observable final class OnboardingViewModel {

    private let repository: UserProfileRepositoryProtocol

    init(repository: UserProfileRepositoryProtocol = UserProfileRepository()) {
        self.repository = repository
    }

    // Step 1 — Photo + Name
    var profileImageData: Data? = nil
    var name: String = ""

    // Step 2 — Biological Sex
    var biologicalSex: BiologicalSex = .male

    // Step 3 — Date of Birth
    var birthDate: Date = Calendar.current.date(
        byAdding: .year, value: -25, to: Date()) ?? Date()

    // Step 2 — Body (skippable)
    var weightKg: String = ""
    var heightCm: String = ""

    // Step 3 — Daily Goals
    var calorieGoal: String = "2000"
    var proteinGoal: String = "150"
    var carbsGoal: String = "200"
    var fatGoal: String = "65"
    var fitnessGoal: FitnessGoal = .maintain
    var showGoalPicker: Bool = false

    // Step 4 — API Key
    var apiKey: String = ""
    var apiProvider: AIProvider = .openAI

    // Step 5 — HealthKit (handled by HealthKit request — no stored state here)

    // Navigation
    var currentStep: Int = 1
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
