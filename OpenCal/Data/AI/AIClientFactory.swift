import Foundation

/// Builds the correct AIClient at runtime based on the saved API key.
/// Returns nil if no key is stored in Keychain.
struct AIClientFactory {
    static func makeClient() -> AIClientProtocol? {
        guard let key = KeychainHelper.load(
            for: AppConstants.Keychain.apiKeyIdentifier
        ), !key.isEmpty else {
            return nil
        }
        // Phase 4: detect Gemini key prefix and return GeminiClient
        // For now, always return OpenAIClient
        return OpenAIClient(apiKey: key)
    }
}
