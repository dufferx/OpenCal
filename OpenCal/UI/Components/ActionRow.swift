import SwiftUI

struct ActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                iconView

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(AppConstants.Typography.mealTitle)
                        .foregroundStyle(AppConstants.Colors.textPrimary)
                        .lineLimit(1)

                    Text(subtitle)
                        .font(AppConstants.Typography.mealSubtitle)
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppConstants.Colors.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var iconView: some View {
        Image(systemName: icon)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(AppConstants.Colors.textPrimary)
            .frame(width: 40, height: 40)
            .background(AppConstants.Colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
