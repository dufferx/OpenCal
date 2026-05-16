import SwiftUI
import PhotosUI

struct FoodScanCameraView: View {
    var viewModel: FoodScanViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var camera = CameraService()
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var localDescription: String = ""
    @FocusState private var descriptionFocused: Bool

    private var isReviewing: Bool { viewModel.capturedImage != nil }

    var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            // 1. Live camera preview — full screen, always visible
            CameraPreviewView(session: camera.session)
                .ignoresSafeArea()

            Color.black.opacity(0.2).ignoresSafeArea()

            // 2. Top bar + shutter — hidden once a photo is captured
            VStack(spacing: 0) {
                if !isReviewing {
                    FoodScanTopBar(selectedPhoto: $selectedPhoto, onDismiss: { dismiss() })
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                Spacer()

                if !isReviewing {
                    FoodScanShutterButton(isCapturing: camera.isCapturing) {
                        camera.capturePhoto { image in
                            guard let image else { return }
                            viewModel.photoSelected(image)
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }

            // 3. Description overlay — slides up after photo is taken
            if isReviewing {
                FoodScanDescriptionOverlay(
                    viewModel: viewModel,
                    localDescription: $localDescription,
                    descriptionFocused: $descriptionFocused,
                    onDismiss: { dismiss() }
                )
            }

            // 4. Analyzing overlay
            if case .analyzing = viewModel.scanState {
                FoodScanAnalyzingOverlay(viewModel: viewModel)
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: isReviewing)
        .animation(.easeInOut(duration: 0.4), value: {
            if case .analyzing = viewModel.scanState { return true }
            return false
        }())
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run { viewModel.photoSelected(uiImage) }
                }
            }
        }
        .onChange(of: viewModel.capturedImage) { _, image in
            if image != nil {
                localDescription = ""
                descriptionFocused = true
            }
        }
        .onChange(of: viewModel.shouldDismiss) { _, newValue in
            if newValue { dismiss() }
        }
        .onAppear  { camera.startSession() }
        .onDisappear { camera.stopSession() }
        .ignoresSafeArea(.container, edges: .all)
        .presentationDetents([.large])
        .presentationCornerRadius(32)
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview

#Preview {
    FoodScanCameraView(viewModel: FoodScanViewModel(repository: FoodRepository()))
}
