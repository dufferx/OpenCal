import SwiftUI

struct MealCardKcalBadge: View {
    let entry: FoodEntry

    var body: some View {
        Text("\(Int(entry.macros.calories)) kcal")
            .font(AppConstants.Typography.macroGoal.bold())
            .foregroundStyle(.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: AppConstants.Spacing.kcalBadgeCornerRadius))
    }
}
