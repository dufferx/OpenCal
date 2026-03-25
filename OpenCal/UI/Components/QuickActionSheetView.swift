import SwiftUI

struct QuickActionSheetView: View {
    var onScanFood: (() -> Void)? = nil
    var onScanLabel: (() -> Void)? = nil
    var onManualEntry: (() -> Void)? = nil
    var onSaveEntry: ((FoodEntry) -> Void)? = nil

    @EnvironmentObject private var appState: AppState
    @StateObject private var scanViewModel = FoodScanViewModel(repository: FoodRepository())
    @State private var showManualEntry = false
    @State private var showFoodScanCamera = false
    @State private var showScanning = false
    @State private var wasShowingConfirmation = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 24) {
            header
            actions
            Spacer()
        }
        .padding(.horizontal, AppConstants.Spacing.screenHorizontal)
        .padding(.top, 24)
        .presentationDetents([.medium])
        .presentationCornerRadius(32)
        .presentationDragIndicator(.visible)
        .presentationBackground(.clear)
        .onAppear {
            scanViewModel.appState = appState
        }
        .sheet(isPresented: $showManualEntry) {
            ManualEntryView { entry in
                onSaveEntry?(entry)
            }
        }
        .sheet(isPresented: $showFoodScanCamera) {
            FoodScanCameraView(viewModel: scanViewModel)
        }
        .sheet(isPresented: $showScanning) {
            if let image = scanViewModel.capturedImage {
                ScanningAnimationView(image: image)
                    .interactiveDismissDisabled()
                    .presentationDetents([.large])
                    .presentationCornerRadius(32)
            }
        }
        .sheet(isPresented: $scanViewModel.showConfirmation) {
            if case .result(let entry, let result) = scanViewModel.scanState {
                FoodScanConfirmationView(
                    entry: entry,
                    result: result,
                    viewModel: scanViewModel,
                    originalImage: scanViewModel.originalImage
                )
            }
        }
        .onChange(of: scanViewModel.scanState) { _, newState in
            if case .analyzing = newState {
                showScanning = true
            } else {
                showScanning = false
            }
            // Retake detection: scanState returns to idle after being in confirmation
            if case .idle = newState, wasShowingConfirmation, !scanViewModel.shouldDismiss {
                wasShowingConfirmation = false
                Task {
                    try? await Task.sleep(for: .milliseconds(350))
                    showFoodScanCamera = true
                }
            }
        }
        .onChange(of: scanViewModel.showConfirmation) { _, isShowing in
            if isShowing {
                wasShowingConfirmation = true
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 6) {
            Text("Add Food")
                .font(AppConstants.Typography.userName)
                .foregroundStyle(AppConstants.Colors.textPrimary)

            Text("How do you want to log?")
                .font(AppConstants.Typography.mealSubtitle)
                .foregroundStyle(AppConstants.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }

    // MARK: - Actions

    private var actions: some View {
        VStack(spacing: 12) {
            ActionRow(
                icon: "camera.fill",
                title: "Scan Food",
                subtitle: "Take a photo of your meal"
            ) {
                if let onScanFood {
                    onScanFood()
                } else {
                    showFoodScanCamera = true
                }
            }

            ActionRow(
                icon: "barcode.viewfinder",
                title: "Scan Label",
                subtitle: "Scan a nutrition label"
            ) {
                if let onScanLabel {
                    onScanLabel()
                } else {
                    print("Scan Label tapped")
                }
            }

            ActionRow(
                icon: "square.and.pencil",
                title: "Manual Entry",
                subtitle: "Enter macros manually"
            ) {
                if let onManualEntry {
                    onManualEntry()
                } else {
                    showManualEntry = true
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    QuickActionSheetView()
        .environmentObject(AppState())
}
