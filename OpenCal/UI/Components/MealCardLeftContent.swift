import SwiftUI

struct MealCardLeftContent: View {
    let entry: FoodEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.name)
                .font(AppConstants.Typography.mealTitle)
                .foregroundStyle(AppConstants.Colors.textPrimary)
                .lineLimit(1)

            Text(entry.source.displayName)
                .font(AppConstants.Typography.mealSubtitle)
                .foregroundStyle(AppConstants.Colors.textSecondary)
                .lineLimit(1)

            Spacer()

            MealCardMacroRow(entry: entry)
        }
        .padding(.vertical, AppConstants.Spacing.cardPadding)
    }
}
