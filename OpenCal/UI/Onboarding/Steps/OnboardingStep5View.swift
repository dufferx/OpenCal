import SwiftUI

struct OnboardingStep5View: View {

    var viewModel: OnboardingViewModel

    @State private var localCalorieGoal: String = ""
    @State private var localProteinGoal: String = ""
    @State private var localCarbsGoal: String = ""
    @State private var localFatGoal: String = ""

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        @Bindable var viewModel = viewModel
        VStack(alignment: .leading, spacing: 0) {

            // Back button row
            HStack {
                Button {
                    viewModel.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppConstants.Colors.textPrimary)
                        .frame(width: 36, height: 36)
                        .glassEffect(.regular, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Go back")
                Spacer()
                Text("5 of 7")
                    .font(AppConstants.Typography.macroGoal)
                    .foregroundStyle(AppConstants.Colors.textTertiary)
            }
            .padding(.top, 16)
            .padding(.horizontal, 20)

            // Title
            Text("Your daily goals")
                .font(.system(size: 34, weight: .bold))
                .padding(.bottom, 4)

            // Subtitle
            Text("You can always change these later")
                .font(AppConstants.Typography.mealSubtitle)
                .foregroundStyle(AppConstants.Colors.textSecondary)
                .padding(.bottom, 28)

            // AI helper button
            Button {
                viewModel.showGoalPicker = true
            } label: {
                HStack(spacing: 6) {
                    Text("✨")
                    Text("Help me set these")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundStyle(AppConstants.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppConstants.Colors.backgroundSecondary, in: RoundedRectangle(cornerRadius: 28))
            }
            .buttonStyle(.plain)
            .padding(.bottom, 24)

            // Divider with label
            HStack(spacing: 12) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(AppConstants.Colors.backgroundSecondary)
                Text("or set manually")
                    .font(AppConstants.Typography.macroGoal)
                    .foregroundStyle(AppConstants.Colors.textTertiary)
                    .fixedSize()
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(AppConstants.Colors.backgroundSecondary)
            }
            .padding(.bottom, 24)

            // 2x2 macro grid
            LazyVGrid(columns: columns, spacing: 16) {
                MacroCellView(label: "Calories", text: $localCalorieGoal, unit: "kcal")
                MacroCellView(label: "Protein",  text: $localProteinGoal,  unit: "g")
                MacroCellView(label: "Carbs",    text: $localCarbsGoal,    unit: "g")
                MacroCellView(label: "Fat",      text: $localFatGoal,      unit: "g")
            }
            .padding(.bottom, 8)

            Spacer()

            // Continue button
            Button {
                viewModel.calorieGoal = localCalorieGoal
                viewModel.proteinGoal = localProteinGoal
                viewModel.carbsGoal = localCarbsGoal
                viewModel.fatGoal = localFatGoal
                viewModel.advance()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppConstants.Colors.ringFilled)
            .controlSize(.large)
            .disabled((Double(localCalorieGoal) ?? 0) <= 0)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 48)
        .onAppear {
            localCalorieGoal = viewModel.calorieGoal
            localProteinGoal = viewModel.proteinGoal
            localCarbsGoal   = viewModel.carbsGoal
            localFatGoal     = viewModel.fatGoal
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppConstants.Colors.backgroundPrimary.ignoresSafeArea())
        .sheet(isPresented: $viewModel.showGoalPicker) {
            FitnessGoalPickerView(viewModel: viewModel)
        }
        .onChange(of: viewModel.showGoalPicker) { _, isShowing in
            if !isShowing {
                localCalorieGoal = viewModel.calorieGoal
                localProteinGoal = viewModel.proteinGoal
                localCarbsGoal   = viewModel.carbsGoal
                localFatGoal     = viewModel.fatGoal
            }
        }
    }

}

#Preview {
    @Previewable @State var vm = OnboardingViewModel()
    OnboardingStep5View(viewModel: vm)
}
