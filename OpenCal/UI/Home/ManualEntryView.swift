import SwiftUI

struct ManualEntryView: View {
    @StateObject private var viewModel = ManualEntryViewModel()
    @Environment(\.dismiss) private var dismiss
    var onSave: (FoodEntry) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    formCard
                    saveButton
                }
                .padding(.horizontal, AppConstants.Spacing.screenHorizontal)
                .padding(.top, 8)
            }
            .background(AppConstants.Colors.backgroundPrimary)
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
    }

    // MARK: - Form card

    private var formCard: some View {
        VStack(spacing: 0) {
            FormRow(
                icon: "pencil",
                label: "Meal Name"
            ) {
                TextField("Breakfast, Lunch...", text: $viewModel.mealName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }

            rowDivider

            FormRow(
                icon: "flame.fill",
                label: "Calories"
            ) {
                TextField("0", value: $viewModel.calories, format: .number)
                    .keyboardType(.decimalPad)
            }

            rowDivider

            FormRow(
                icon: "fork.knife",
                label: "Protein"
            ) {
                TextField("0", value: $viewModel.protein, format: .number)
                    .keyboardType(.decimalPad)
            }

            rowDivider

            FormRow(
                icon: "takeoutbag.and.cup.and.straw.fill",
                label: "Carbs"
            ) {
                TextField("0", value: $viewModel.carbs, format: .number)
                    .keyboardType(.decimalPad)
            }

            rowDivider

            FormRow(
                icon: "drop.fill",
                label: "Fat"
            ) {
                TextField("0", value: $viewModel.fat, format: .number)
                    .keyboardType(.decimalPad)
            }
        }
        .background(AppConstants.Colors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
    }

    private var rowDivider: some View {
        Divider()
            .padding(.leading, 56)
    }

    // MARK: - Save button

    private var saveButton: some View {
        Button {
            guard let entry = viewModel.buildEntry() else { return }
            onSave(entry)
            dismiss()
        } label: {
            Text("Add Meal")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(AppConstants.Colors.ringFilled)
        .controlSize(.large)
        .disabled(!viewModel.isValid)
    }
}

// MARK: - Preview

#Preview {
    ManualEntryView { entry in
        print("Saved: \(entry.name)")
    }
}
