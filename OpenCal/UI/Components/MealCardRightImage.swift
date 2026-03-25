import SwiftUI

struct MealCardRightImage: View {
    let entry: FoodEntry

    var body: some View {
        ZStack(alignment: .bottom) {
            MealCardMealImage(entry: entry)
                .frame(
                    width: AppConstants.Spacing.mealImageSize,
                    height: AppConstants.Spacing.mealCardHeight
                )
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: AppConstants.Spacing.cardCornerRadius,
                    bottomLeadingRadius: AppConstants.Spacing.cardCornerRadius,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                ))

            MealCardKcalBadge(entry: entry)
                .padding(6)
        }
    }
}
