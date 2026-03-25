import SwiftUI

struct MealCardMacroRow: View {
    let entry: FoodEntry

    var body: some View {
        HStack(spacing: 8) {
            MacroChip(icon: "bolt.fill", value: entry.macros.protein, unit: "g")
            MacroChip(icon: "leaf.fill", value: entry.macros.carbs, unit: "g")
            MacroChip(icon: "drop.fill", value: entry.macros.fat, unit: "g")
        }
    }
}
