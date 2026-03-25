import Foundation

// MARK: - Result model (note: MacroNutrients must be defined in Domain/Models)
struct FoodAnalysisResult: Codable, Equatable {
    let name: String
    let description: String
    let macros: MacroNutrients
    let confidence: Double
    let notes: String
}

// MARK: - Error types
enum AIAnalysisError: LocalizedError {
    case noAPIKey
    case invalidAPIKey
    case imageTooLarge
    case unrecognizedFood
    case malformedResponse(String)
    case networkError(Error)
    case rateLimitExceeded
    case macroInconsistency

    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "No API key configured. Please add your API key in Settings."
        case .invalidAPIKey:
            return "Invalid API key. Please check your key in Settings."
        case .imageTooLarge:
            return "Image is too large to analyze. Please try again."
        case .unrecognizedFood:
            return "Couldn't identify the food. Try adding a description or use manual entry."
        case .malformedResponse(let detail):
            return "Unexpected response from AI: \(detail)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .rateLimitExceeded:
            return "Too many requests. Please wait a moment and try again."
        case .macroInconsistency:
            return "AI returned inconsistent nutrition values. Please verify manually."
        }
    }
}

// MARK: - Protocol
protocol AIClientProtocol {
    func analyzeFoodImage(
        _ imageData: Data,
        userDescription: String?
    ) async throws -> FoodAnalysisResult

    func analyzeNutritionLabel(
        _ imageData: Data
    ) async throws -> MacroNutrients
}
