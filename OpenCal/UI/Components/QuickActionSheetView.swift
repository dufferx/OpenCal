import SwiftUI

struct QuickActionSheetView: View {
    var onScanFood: (() -> Void)? = nil
    var onScanLabel: (() -> Void)? = nil
    var onManualEntry: (() -> Void)? = nil
    var onOpenFoodLog: (() -> Void)? = nil
    var onSaveEntry: ((FoodEntry) -> Void)? = nil

    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var scanViewModel = FoodScanViewModel(repository: FoodRepository())
    @State private var showManualEntry = false
    @State private var showFoodScanCamera = false
    @State private var showScanning = false
    @State private var wasShowingConfirmation = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    actionsCard
                }
                .padding(.horizontal, AppConstants.Spacing.screenHorizontal)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(AppConstants.Colors.backgroundPrimary)
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationCornerRadius(32)
        .presentationDragIndicator(.visible)
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
        VStack(alignment: .leading, spacing: 6) {
            Text("Quick add")
                .font(AppConstants.Typography.mealTitle)
                .foregroundStyle(AppConstants.Colors.textPrimary)

            Text("Choose how you want to log this meal.")
                .font(AppConstants.Typography.mealSubtitle)
                .foregroundStyle(AppConstants.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Actions

    private var actionsCard: some View {
        VStack(spacing: 0) {
            ActionRow(
                icon: "camera.fill",
                title: "Scan Food",
                subtitle: "Take a photo of your meal"
            ) {
                handleScanFood()
            }

            rowDivider

            ActionRow(
                icon: "barcode.viewfinder",
                title: "Scan Label",
                subtitle: "Scan a nutrition label"
            ) {
                handleScanLabel()
            }

            rowDivider

            ActionRow(
                icon: "square.and.pencil",
                title: "Manual Entry",
                subtitle: "Enter macros manually"
            ) {
                handleManualEntry()
            }

            rowDivider

            ActionRow(
                icon: "clock.arrow.circlepath",
                title: "From Food Log",
                subtitle: "Add a meal you logged before"
            ) {
                handleOpenFoodLog()
            }
        }
        .background(AppConstants.Colors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
        .shadow(
            color: AppConstants.Shadow.cardColor.opacity(0.08),
            radius: 12,
            x: 0,
            y: 6
        )
    }

    private var rowDivider: some View {
        Divider()
            .padding(.leading, 76)
    }

    // MARK: - Actions

    private func handleScanFood() {
        if let onScanFood {
            onScanFood()
        } else {
            showFoodScanCamera = true
        }
    }

    private func handleScanLabel() {
        if let onScanLabel {
            onScanLabel()
        } else {
            print("Scan Label tapped")
        }
    }

    private func handleManualEntry() {
        if let onManualEntry {
            onManualEntry()
        } else {
            showManualEntry = true
        }
    }

    private func handleOpenFoodLog() {
        if let onOpenFoodLog {
            onOpenFoodLog()
        } else {
            appState.selectedTab = .foodLog
        }

        dismiss()
    }
}

// MARK: - Preview

#Preview {
    QuickActionSheetView()
        .environment(AppState())
}
