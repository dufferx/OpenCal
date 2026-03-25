import SwiftUI

struct MacroChip: View {
    let icon: String
    let value: Double
    let unit: String

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
                .font(AppConstants.Typography.macroGoal)
                .foregroundStyle(AppConstants.Colors.textSecondary)

            Text("\(Int(value))\(unit)")
                .font(AppConstants.Typography.macroGoal)
                .foregroundStyle(AppConstants.Colors.textSecondary)
        }
    }
}
