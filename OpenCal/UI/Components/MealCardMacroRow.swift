import SwiftUI

struct MealCardMacroRow: View {
    let entry: FoodEntry

    var body: some View {
        HStack(spacing: 8) {
            MacroChip(icon: "proteinIcon", value: entry.macros.protein, unit: "g")
            MacroChip(icon: "carbsIcon", value: entry.macros.carbs, unit: "g")
            MacroChip(icon: "fatIcon", value: entry.macros.fat, unit: "g")
        }
    }
}
