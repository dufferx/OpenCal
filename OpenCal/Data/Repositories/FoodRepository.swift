import SwiftData
import Foundation

actor FoodRepository: FoodRepositoryProtocol {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer = .shared) {
        self.modelContainer = modelContainer
    }

    // MARK: - Daily log

    func fetchLog(for date: Date) async throws -> DailyLog {
        let context = ModelContext(modelContainer)
        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let endOfDay = Calendar.current.date(
            byAdding: .day, value: 1, to: startOfDay
        ) else { return DailyLog(date: date, entries: []) }

        let predicate = #Predicate<FoodEntryRecord> { record in
            record.logDate >= startOfDay && record.logDate < endOfDay
        }
        let descriptor = FetchDescriptor<FoodEntryRecord>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp)]
        )
        let records = try context.fetch(descriptor)
        let entries = records.map { $0.toDomainModel() }
        return DailyLog(date: date, entries: entries)
    }

    func saveEntry(_ entry: FoodEntry, for date: Date) async throws {
        let context = ModelContext(modelContainer)
        let record = FoodEntryRecord(from: entry, logDate: date)
        context.insert(record)
        try context.save()
    }

    func deleteEntry(id: UUID, for date: Date) async throws {
        let context = ModelContext(modelContainer)
        let predicate = #Predicate<FoodEntryRecord> { $0.id == id }
        let descriptor = FetchDescriptor<FoodEntryRecord>(predicate: predicate)
        let records = try context.fetch(descriptor)
        for record in records { context.delete(record) }
        try context.save()
    }

    // MARK: - Library (phase 2)

    func fetchAllLibraryItems() async throws -> [FoodEntry] { [] }
    func saveToLibrary(_ entry: FoodEntry) async throws {}
    func deleteFromLibrary(id: UUID) async throws {}
}
