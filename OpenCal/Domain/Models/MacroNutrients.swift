import Foundation

struct MacroNutrients: Codable, Equatable {
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double

    static let zero = MacroNutrients(calories: 0, protein: 0, carbs: 0, fat: 0)

    var isValid: Bool {
        calories >= 0 && protein >= 0 && carbs >= 0 && fat >= 0
    }
}
