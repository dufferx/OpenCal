import SwiftUI

struct FoodScanConfirmationView: View {
    let entry: FoodEntry
    let result: FoodAnalysisResult
    let originalImage: UIImage?
    var viewModel: FoodScanViewModel
    @Environment(\.dismiss) private var dismiss

    // Editable state — user can adjust before saving
    @State private var editedName: String
    @State private var editedCalories: String
    @State private var editedProtein: String
    @State private var editedCarbs: String
    @State private var editedFat: String

    init(entry: FoodEntry, result: FoodAnalysisResult, viewModel: FoodScanViewModel, originalImage: UIImage?) {
        self.entry = entry
        self.result = result
        self.viewModel = viewModel
        self.originalImage = originalImage
        _editedName = State(initialValue: entry.name)
        _editedCalories = State(initialValue: String(Int(entry.macros.calories)))
        _editedProtein = State(initialValue: entry.macros.protein.formatted(.number.precision(.fractionLength(1))))
        _editedCarbs = State(initialValue: entry.macros.carbs.formatted(.number.precision(.fractionLength(1))))
        _editedFat = State(initialValue: entry.macros.fat.formatted(.number.precision(.fractionLength(1))))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Food image
                    if let original = originalImage {
                        Image(uiImage: original)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(
                                cornerRadius: AppConstants.Spacing.cardCornerRadius))
                            .padding(.horizontal, 16)
                    } else if let imageData = entry.imageData,
                              let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(
                                cornerRadius: AppConstants.Spacing.cardCornerRadius))
                            .padding(.horizontal, 16)
                    }

                    // AI description
                    Text(result.description)
                        .font(AppConstants.Typography.mealSubtitle)
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                        .padding(.horizontal, 16)

                    // Confidence badge
                    HStack(spacing: 6) {
                        Circle()
                            .fill(confidenceSwiftUIColor)
                            .frame(width: 8, height: 8)
                        Text(viewModel.confidenceLabel(for: result.confidence))
                            .font(AppConstants.Typography.macroGoal)
                            .foregroundStyle(AppConstants.Colors.textSecondary)
                    }
                    .padding(.horizontal, 16)

                    Divider().padding(.horizontal, 16)

                    // Editable fields
                    VStack(spacing: 16) {
                        FoodScanEditField(label: "Meal name", value: $editedName,
                                         keyboard: .default)

                        // Macros grid 2x2
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            FoodScanEditField(label: "Calories (kcal)", value: $editedCalories,
                                             keyboard: .decimalPad)
                            FoodScanEditField(label: "Protein (g)", value: $editedProtein,
                                             keyboard: .decimalPad)
                            FoodScanEditField(label: "Carbs (g)", value: $editedCarbs,
                                             keyboard: .decimalPad)
                            FoodScanEditField(label: "Fat (g)", value: $editedFat,
                                             keyboard: .decimalPad)
                        }
                    }
                    .padding(.horizontal, 16)

                    // Notes from AI (if any)
                    if !result.notes.isEmpty {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(AppConstants.Colors.textTertiary)
                            Text(result.notes)
                                .font(AppConstants.Typography.macroGoal)
                                .foregroundStyle(AppConstants.Colors.textTertiary)
                        }
                        .padding(.horizontal, 16)
                    }

                    Spacer().frame(height: 100)
                }
                .padding(.top, 8)
            }
            .navigationTitle("Review Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Retake") {
                        dismiss()
                        viewModel.retake()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button("Add to Log") {
                    let edited = buildEditedEntry()
                    Task {
                        await viewModel.confirmAndSave(entry: edited)
                        dismiss()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppConstants.Colors.textPrimary,
                            in: RoundedRectangle(cornerRadius: 28))
                .foregroundStyle(.white)
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .presentationDetents([.large])
        .presentationCornerRadius(32)
        .presentationDragIndicator(.visible)
    }

    // MARK: - Build edited entry
    private func buildEditedEntry() -> FoodEntry {
        let macros = MacroNutrients(
            calories: Double(editedCalories) ?? entry.macros.calories,
            protein: Double(editedProtein) ?? entry.macros.protein,
            carbs: Double(editedCarbs) ?? entry.macros.carbs,
            fat: Double(editedFat) ?? entry.macros.fat
        )
        return FoodEntry(
            id: entry.id,
            name: editedName.trimmingCharacters(in: .whitespaces).isEmpty
                ? entry.name
                : editedName,
            macros: macros,
            portionGrams: entry.portionGrams,
            timestamp: entry.timestamp,
            imageData: entry.imageData,
            source: entry.source
        )
    }

    // MARK: - Confidence color
    private var confidenceSwiftUIColor: Color {
        switch result.confidence {
        case 0.6...: return .green
        case 0.4..<0.6: return .orange
        default: return .red
        }
    }
}

// MARK: - Preview

#if DEBUG
private struct ConfirmationPreviewRepository: FoodRepositoryProtocol {
    func fetchLog(for date: Date) async throws -> DailyLog { DailyLog(date: date, entries: []) }
    func saveEntry(_ entry: FoodEntry, for date: Date) async throws {}
    func deleteEntry(id: UUID, for date: Date) async throws {}
    func fetchAllLibraryItems() async throws -> [FoodEntry] { [] }
    func saveToLibrary(_ entry: FoodEntry) async throws {}
    func deleteFromLibrary(id: UUID) async throws {}
}
#endif

#Preview("High confidence") {
    let macros = MacroNutrients(calories: 485, protein: 32.5, carbs: 48.0, fat: 16.0)
    let entry = FoodEntry(
        id: UUID(),
        name: "Grilled Chicken Salad",
        macros: macros,
        portionGrams: nil,
        timestamp: Date(),
        imageData: nil,
        source: .foodScan
    )
    let result = FoodAnalysisResult(
        name: "Grilled Chicken Salad",
        description: "A fresh salad with grilled chicken breast, mixed greens, cherry tomatoes, and light vinaigrette dressing.",
        macros: macros,
        confidence: 0.82,
        notes: "Dressing calories estimated at 60 kcal. Portion size estimated from standard dinner plate."
    )
    FoodScanConfirmationView(
        entry: entry,
        result: result,
        viewModel: FoodScanViewModel(repository: ConfirmationPreviewRepository()),
        originalImage: nil
    )
}

#Preview("Low confidence") {
    let macros = MacroNutrients(calories: 320, protein: 14.0, carbs: 38.0, fat: 12.0)
    let entry = FoodEntry(
        id: UUID(),
        name: "Mixed Dish",
        macros: macros,
        portionGrams: nil,
        timestamp: Date(),
        imageData: nil,
        source: .foodScan
    )
    let result = FoodAnalysisResult(
        name: "Mixed Dish",
        description: "A partially visible mixed dish — possibly a stew or casserole with vegetables.",
        macros: macros,
        confidence: 0.35,
        notes: "Image was partially obscured. Consider editing values manually."
    )
    FoodScanConfirmationView(
        entry: entry,
        result: result,
        viewModel: FoodScanViewModel(repository: ConfirmationPreviewRepository()),
        originalImage: nil
    )
}
