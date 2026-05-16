import SwiftUI

struct FoodScanAnalyzingOverlay: View {
    var viewModel: FoodScanViewModel

    var body: some View {
        Group {
            if let image = viewModel.capturedImage {
                ScanningAnimationView(image: image)
            } else {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView().tint(.white)
                    }
            }
        }
    }
}
