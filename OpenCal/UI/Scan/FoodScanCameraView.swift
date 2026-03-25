import SwiftUI
import UIKit
import PhotosUI
import AVFoundation

struct FoodScanCameraView: View {
    @ObservedObject var viewModel: FoodScanViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var localDescription: String = ""
    @FocusState private var descriptionFocused: Bool

    var body: some View {
        ZStack {
            // 1. Live camera preview — always visible
            CameraPreviewView()
                .ignoresSafeArea()

            Color.black.opacity(0.2).ignoresSafeArea()

            // 2. Top bar + shutter (shutter hidden when reviewing)
            VStack(spacing: 0) {
                FoodScanTopBar(selectedPhoto: $selectedPhoto, onDismiss: { dismiss() })
                Spacer()

                if viewModel.capturedImage == nil {
                    FoodScanShutterButton(viewModel: viewModel)
                }
            }

            // 3. Description overlay — slides up when photo is taken
            if viewModel.capturedImage != nil {
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
        .animation(.easeInOut(duration: 0.4), value: {
            if case .analyzing = viewModel.scanState { return true }
            return false
        }())
        .sheet(isPresented: $viewModel.showCamera) {
            CameraPickerView(sourceType: .camera) { image in
                viewModel.photoSelected(image)
            }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        viewModel.photoSelected(uiImage)
                    }
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
        .ignoresSafeArea(.container, edges: .all)  // ignores device edges but NOT keyboard
        .presentationDetents([.large])
        .presentationCornerRadius(32)
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview

#Preview {
    FoodScanCameraView(viewModel: FoodScanViewModel(repository: FoodRepository()))
}
