import SwiftUI

struct CalorieArcLabels: View {
    let formattedConsumed: String
    let formattedGoal: String

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: "flame.fill")
                .font(.system(size: 24))
                .foregroundStyle(AppConstants.Colors.textPrimary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(formattedConsumed)
                    .font(AppConstants.Typography.calorieCount)
                    .foregroundStyle(AppConstants.Colors.textPrimary)

                Text("kcal")
                    .font(AppConstants.Typography.calorieUnit)
                    .foregroundStyle(AppConstants.Colors.textPrimary)
            }

            Text("of \(formattedGoal)")
                .font(AppConstants.Typography.calorieGoal)
                .foregroundStyle(AppConstants.Colors.textSecondary)
        }
    }
}
