import SwiftUI

struct ActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                iconView

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppConstants.Typography.mealTitle)
                        .foregroundStyle(AppConstants.Colors.textPrimary)

                    Text(subtitle)
                        .font(AppConstants.Typography.mealSubtitle)
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppConstants.Colors.textTertiary)
            }
            .padding(16)
            .glassEffect(in: RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
        }
        .buttonStyle(.plain)
    }

    private var iconView: some View {
        Image(systemName: icon)
            .font(.system(size: 22))
            .foregroundStyle(AppConstants.Colors.textPrimary)
            .frame(width: 44, height: 44)
            .background(AppConstants.Colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
