import SwiftUI

struct FitnessGoalPickerView: View {

    var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What's your goal?")
                .font(AppConstants.Typography.userName)
                .padding(.top, 8)

            ForEach(FitnessGoal.allCases) { goal in
                goalCard(goal)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .presentationDetents([.medium])
        .presentationCornerRadius(32)
    }

    @ViewBuilder
    private func goalCard(_ goal: FitnessGoal) -> some View {
        let isSelected = viewModel.fitnessGoal == goal

        Button {
            viewModel.fitnessGoal    = goal
            viewModel.calorieGoal    = goal.defaultCalories
            viewModel.proteinGoal    = goal.defaultProtein
            viewModel.carbsGoal      = goal.defaultCarbs
            viewModel.fatGoal        = goal.defaultFat
            viewModel.showGoalPicker = false
        } label: {
            HStack(spacing: 16) {
                Image(systemName: goal.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(AppConstants.Colors.textPrimary)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.rawValue)
                        .font(AppConstants.Typography.macroLabel)
                        .foregroundStyle(AppConstants.Colors.textPrimary)
                    Text(subtitle(for: goal))
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                }

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                isSelected
                    ? AppConstants.Colors.backgroundCard
                    : AppConstants.Colors.backgroundSecondary,
                in: RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius)
                    .strokeBorder(
                        isSelected ? AppConstants.Colors.textPrimary : Color.clear,
                        lineWidth: 2
                    )
            )
            .glassEffect(in: RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
        }
        .buttonStyle(.plain)
    }

    private func subtitle(for goal: FitnessGoal) -> String {
        switch goal {
        case .lose:     return "Caloric deficit"
        case .maintain: return "Balanced intake"
        case .gain:     return "Caloric surplus"
        }
    }
}
