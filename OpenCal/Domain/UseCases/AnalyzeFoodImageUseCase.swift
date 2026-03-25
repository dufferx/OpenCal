import Foundation
import UIKit

struct AnalyzeFoodImageUseCase {

    private let aiClient: AIClientProtocol

    init(aiClient: AIClientProtocol) {
        self.aiClient = aiClient
    }

    /// Analyzes a food image and returns a ready-to-save FoodEntry.
    /// The entry is NOT saved — the ViewModel decides what to do with it.
    func execute(
        image: UIImage,
        userDescription: String?
    ) async throws -> (entry: FoodEntry, result: FoodAnalysisResult) {

        guard let imageData = image.jpegData(compressionQuality: 0.85) else {
            throw AIAnalysisError.malformedResponse("Could not encode image")
        }

        let result = try await aiClient.analyzeFoodImage(
            imageData,
            userDescription: userDescription
        )

        let entry = FoodEntry(
            id: UUID(),
            name: result.name,
            macros: result.macros,
            portionGrams: nil,
            timestamp: Date(),
            imageData: imageData,
            source: .foodScan
        )

        return (entry: entry, result: result)
    }
}

// MARK: - Convenience factory initializer
extension AnalyzeFoodImageUseCase {
    /// Creates the use case using the stored API key from Keychain.
    /// Throws AIAnalysisError.noAPIKey if no key is configured.
    static func makeWithStoredKey() throws -> AnalyzeFoodImageUseCase {
        guard let client = AIClientFactory.makeClient() else {
            throw AIAnalysisError.noAPIKey
        }
        return AnalyzeFoodImageUseCase(aiClient: client)
    }
}
