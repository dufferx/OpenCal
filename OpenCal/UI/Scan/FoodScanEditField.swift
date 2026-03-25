import SwiftUI

struct FoodScanEditField: View {
    let label: String
    @Binding var value: String
    let keyboard: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(AppConstants.Typography.macroGoal)
                .foregroundStyle(AppConstants.Colors.textSecondary)
            TextField(label, text: $value)
                .keyboardType(keyboard)
                .padding(10)
                .background(AppConstants.Colors.backgroundSecondary,
                            in: RoundedRectangle(cornerRadius: 10))
                .font(AppConstants.Typography.macroLabel)
        }
    }
}
