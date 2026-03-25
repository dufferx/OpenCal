import SwiftUI

struct MacroRingInfo: View {
    let formattedCurrent: String
    let formattedGoal: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(formattedCurrent)
                .font(AppConstants.Typography.macroValue)
                .foregroundStyle(AppConstants.Colors.textPrimary)

            Text(formattedGoal)
                .font(AppConstants.Typography.macroGoal)
                .foregroundStyle(AppConstants.Colors.textSecondary)

            Text(label)
                .font(AppConstants.Typography.macroLabel)
                .foregroundStyle(AppConstants.Colors.textPrimary)
        }
    }
}
