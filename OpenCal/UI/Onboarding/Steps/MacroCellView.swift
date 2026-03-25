import SwiftUI

struct MacroCellView: View {
    let label: String
    @Binding var text: String
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(AppConstants.Typography.macroLabel)
                .foregroundStyle(AppConstants.Colors.textSecondary)
            HStack(spacing: 4) {
                TextField("0", text: $text)
                    .keyboardType(.decimalPad)
                    .font(AppConstants.Typography.mealSubtitle)
                Text(unit)
                    .font(AppConstants.Typography.macroGoal)
                    .foregroundStyle(AppConstants.Colors.textTertiary)
            }
            .padding(12)
            .background(AppConstants.Colors.backgroundSecondary, in: RoundedRectangle(cornerRadius: 10))
        }
    }
}
