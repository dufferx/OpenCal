import Foundation
import Observation

@Observable final class ManualEntryViewModel {
    var mealName: String = ""
    var calories: Double = 0
    var protein: Double = 0
    var carbs: Double = 0
    var fat: Double = 0

    var isValid: Bool {
        !mealName.trimmingCharacters(in: .whitespaces).isEmpty && calories > 0
    }

    func buildEntry() -> FoodEntry? {
        guard isValid else { return nil }
        let macros = MacroNutrients(
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat
        )
        guard macros.isValid else { return nil }
        return FoodEntry(
            id: UUID(),
            name: mealName.trimmingCharacters(in: .whitespaces),
            macros: macros,
            portionGrams: nil,
            timestamp: Date.now,
            imageData: nil,
            source: .manual
        )
    }
}
