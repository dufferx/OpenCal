import Foundation
import Observation

enum AppTab: String {
    case home
    case progress
    case foodLog
    case add
}

@Observable @MainActor
final class AppState {
    var selectedTab: AppTab = .home
    var hasCompletedOnboarding: Bool

    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        hasCompletedOnboarding = true
    }
}
