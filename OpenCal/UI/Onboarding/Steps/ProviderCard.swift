import SwiftUI

struct ProviderCard: View {

    let title: String
    let subtitle: String
    let provider: AIProvider
    let selected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(selected ? Color.white : AppConstants.Colors.textPrimary)
                    Text(subtitle)
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(selected ? Color.white.opacity(0.6) : AppConstants.Colors.textSecondary)
                }
                Spacer()
                if selected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.white)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                selected ? AppConstants.Colors.textPrimary : AppConstants.Colors.backgroundSecondary,
                in: RoundedRectangle(cornerRadius: 20)
            )
        }
        .buttonStyle(.plain)
    }
}
