import SwiftUI

struct FormRow<Field: View>: View {
    let icon: String
    let label: String
    @ViewBuilder let field: () -> Field
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(AppConstants.Colors.textPrimary)
                .frame(width: 32, height: 32)

            Text(label)
                .font(AppConstants.Typography.macroLabel)
                .foregroundStyle(AppConstants.Colors.textPrimary)

            Spacer(minLength: 12)

            field()
                .multilineTextAlignment(.trailing)
                .font(AppConstants.Typography.macroLabel)
                .foregroundStyle(AppConstants.Colors.textPrimary)
                .focused($isFocused)
        }
        .padding(.horizontal, AppConstants.Spacing.cardPadding)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .accessibilityAddTraits(.isButton)
    }
}
