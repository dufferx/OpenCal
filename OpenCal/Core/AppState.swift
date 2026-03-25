import Foundation
import Combine

class AppState: ObservableObject {
    @Published var selectedTab: String = "home"
    @Published var hasCompletedOnboarding: Bool

    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        Task { @MainActor in
            self.hasCompletedOnboarding = true
        }
    }
}
