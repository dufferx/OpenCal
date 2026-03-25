import Foundation

enum FoodEntrySource: String, Codable, Equatable {
    case manual
    case foodScan
    case labelScan
    case library
}

struct FoodEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let macros: MacroNutrients
    let portionGrams: Double?
    let timestamp: Date
    let imageData: Data?
    let source: FoodEntrySource
}
