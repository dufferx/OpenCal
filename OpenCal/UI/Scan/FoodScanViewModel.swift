import Foundation
import UIKit
import Observation

@MainActor
@Observable
class FoodScanViewModel {

    // MARK: - Camera state
    var capturedImage: UIImage? = nil
    var originalImage: UIImage? = nil  // original, uncompressed — for display
    var userDescription: String = ""

    // MARK: - Analysis state
    enum ScanState: Equatable {
        case idle           // waiting for photo
        case reviewing      // photo taken, not yet analyzed
        case analyzing      // API call in progress
        case result(FoodEntry, FoodAnalysisResult)  // success
        case error(String)  // failure message

        static func == (lhs: ScanState, rhs: ScanState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle): return true
            case (.reviewing, .reviewing): return true
            case (.analyzing, .analyzing): return true
            case (.error(let a), .error(let b)): return a == b
            case (.result, .result): return true
            default: return false
            }
        }
    }
    var scanState: ScanState = .idle

    // MARK: - Sheet/navigation flags
    var showConfirmation: Bool = false
    var shouldDismiss: Bool = false

    // MARK: - Dependencies
    private let repository: FoodRepositoryProtocol
    weak var appState: AppState?
    var onScanComplete: ((FoodEntry) -> Void)?

    init(repository: FoodRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Actions

    /// Called when the user captures or selects a photo.
    func photoSelected(_ image: UIImage) {
        capturedImage = image
        originalImage = image
        scanState = .reviewing
    }

    /// Called when the user taps "Analyze" after optionally adding description.
    func analyzeImage() async {
        guard let image = capturedImage else {
            scanState = .error("Could not process image. Please try again.")
            return
        }

        scanState = .analyzing

        do {
            let useCase = try AnalyzeFoodImageUseCase.makeWithStoredKey()
            let description = userDescription.trimmingCharacters(in: .whitespaces)
            let (entry, result) = try await useCase.execute(
                image: image,
                userDescription: description.isEmpty ? nil : description
            )
            scanState = .result(entry, result)
            // Brief pause so the scanning animation sheet can begin dismissing
            // before the confirmation sheet tries to appear.
            try? await Task.sleep(for: .milliseconds(350))
            showConfirmation = true
        } catch let error as AIAnalysisError {
            scanState = .error(error.localizedDescription)
        } catch {
            scanState = .error(error.localizedDescription)
        }
    }

    /// Called when user confirms the result and saves to today's log.
    func confirmAndSave(entry: FoodEntry) async {
        do {
            try await repository.saveEntry(entry, for: Date())
            onScanComplete?(entry)
            appState?.selectedTab = .home
            shouldDismiss = true
            resetToIdle()
        } catch {
            scanState = .error("Failed to save meal. Please try again.")
        }
    }

    /// Called when user discards the result and wants to retake.
    func retake() {
        capturedImage = nil
        originalImage = nil
        userDescription = ""
        scanState = .idle
        showConfirmation = false
        shouldDismiss = false
    }

    func resetToIdle() {
        capturedImage = nil
        originalImage = nil
        userDescription = ""
        scanState = .idle
        showConfirmation = false
        // shouldDismiss is intentionally NOT reset here — it is set once in
        // confirmAndSave() and must remain true long enough for FoodScanView's
        // onChange to fire. Resetting it here would cancel the dismiss in the
        // same synchronous batch and SwiftUI would never see the true value.
    }

    // MARK: - Confidence helper
    func confidenceLabel(for confidence: Double) -> String {
        switch confidence {
        case 0.8...: return "High confidence"
        case 0.6..<0.8: return "Good estimate"
        case 0.4..<0.6: return "Moderate estimate"
        default: return "Low confidence — consider editing"
        }
    }

    func confidenceColor(for confidence: Double) -> String {
        // Returns SF Symbol color name — used in View
        switch confidence {
        case 0.6...: return "green"
        case 0.4..<0.6: return "orange"
        default: return "red"
        }
    }
}
