import SwiftUI

struct MealCard: View {
    let entry: FoodEntry
    let onSaveToLibrary: (() -> Void)?

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            MealCardLeftContent(entry: entry)
                .padding(.leading, AppConstants.Spacing.cardPadding)
            Spacer()
            MealCardRightImage(entry: entry)
        }
        .frame(height: AppConstants.Spacing.mealCardHeight)
        .background(AppConstants.Colors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
        .padding(.horizontal, AppConstants.Spacing.screenHorizontal)
    }
}

// MARK: - FoodEntrySource display name

extension FoodEntrySource {
    var displayName: String {
        switch self {
        case .manual:    return "Manual entry"
        case .foodScan:  return "Food scan"
        case .labelScan: return "Label scan"
        case .library:   return "From library"
        }
    }
}

// MARK: - Preview

#Preview {
    let macros = MacroNutrients(calories: 350, protein: 15, carbs: 42, fat: 11)
    let entry = FoodEntry(
        id: UUID(),
        name: "Desayuno",
        macros: macros,
        portionGrams: nil,
        timestamp: Date(),
        imageData: nil,
        source: .foodScan
    )

    VStack(spacing: 12) {
        MealCard(entry: entry, onSaveToLibrary: nil)
        MealCard(entry: entry, onSaveToLibrary: { print("Save to library") })
    }
    .padding(.vertical)
    .background(AppConstants.Colors.backgroundPrimary)
}
