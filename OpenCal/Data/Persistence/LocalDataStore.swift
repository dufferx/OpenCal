import SwiftData
import Foundation

// SwiftData persistent model — Data layer only, never imported by Domain or UI

@Model
final class FoodEntryRecord {
    var id: UUID
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var portionGrams: Double?
    var timestamp: Date
    var imageData: Data?
    var sourceRaw: String
    var logDate: Date

    init(from entry: FoodEntry, logDate: Date) {
        self.id = entry.id
        self.name = entry.name
        self.calories = entry.macros.calories
        self.protein = entry.macros.protein
        self.carbs = entry.macros.carbs
        self.fat = entry.macros.fat
        self.portionGrams = entry.portionGrams
        self.timestamp = entry.timestamp
        self.imageData = entry.imageData
        self.sourceRaw = entry.source.rawValue
        self.logDate = logDate
    }

    func toDomainModel() -> FoodEntry {
        FoodEntry(
            id: id,
            name: name,
            macros: MacroNutrients(
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat
            ),
            portionGrams: portionGrams,
            timestamp: timestamp,
            imageData: imageData,
            source: FoodEntrySource(rawValue: sourceRaw) ?? .manual
        )
    }
}

// MARK: - Shared ModelContainer

extension ModelContainer {
    nonisolated(unsafe) static var shared: ModelContainer = {
        let schema = Schema([FoodEntryRecord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("SwiftData ModelContainer failed to initialize: \(error)")
        }
    }()
}
