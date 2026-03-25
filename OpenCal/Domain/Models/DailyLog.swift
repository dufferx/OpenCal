import Foundation

struct DailyLog: Codable, Equatable {
    let date: Date
    let entries: [FoodEntry]

    var totalMacros: MacroNutrients {
        entries.reduce(.zero) { acc, entry in
            MacroNutrients(
                calories: acc.calories + entry.macros.calories,
                protein: acc.protein + entry.macros.protein,
                carbs: acc.carbs + entry.macros.carbs,
                fat: acc.fat + entry.macros.fat
            )
        }
    }

    var totalCalories: Double {
        totalMacros.calories
    }
}

#if DEBUG
extension DailyLog {
    static var mock: DailyLog {
        DailyLog(date: .now, entries: [
            FoodEntry(
                id: UUID(),
                name: "Desayuno",
                macros: MacroNutrients(calories: 350, protein: 15, carbs: 15, fat: 15),
                portionGrams: nil,
                timestamp: .now,
                imageData: nil,
                source: .manual
            ),
            FoodEntry(
                id: UUID(),
                name: "Almuerzo",
                macros: MacroNutrients(calories: 500, protein: 30, carbs: 45, fat: 20),
                portionGrams: nil,
                timestamp: .now,
                imageData: nil,
                source: .manual
            )
        ])
    }
}
#endif
