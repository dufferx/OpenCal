import Foundation

enum BiologicalSex: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    var id: String { rawValue }
}

enum FitnessGoal: String, CaseIterable, Identifiable {
    case lose = "Lose weight"
    case maintain = "Maintain weight"
    case gain = "Gain muscle"
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .lose: return "flame.fill"
        case .maintain: return "equal.circle.fill"
        case .gain: return "bolt.fill"
        }
    }

    var defaultCalories: String {
        switch self { case .lose: return "1600"; case .maintain: return "2000"; case .gain: return "2500" }
    }
    var defaultProtein: String {
        switch self { case .lose: return "160"; case .maintain: return "150"; case .gain: return "180" }
    }
    var defaultCarbs: String {
        switch self { case .lose: return "150"; case .maintain: return "200"; case .gain: return "280" }
    }
    var defaultFat: String {
        switch self { case .lose: return "55"; case .maintain: return "65"; case .gain: return "80" }
    }
}

enum AIProvider: String, CaseIterable, Identifiable {
    case openAI = "OpenAI"
    case gemini = "Gemini"
    var id: String { rawValue }
}
