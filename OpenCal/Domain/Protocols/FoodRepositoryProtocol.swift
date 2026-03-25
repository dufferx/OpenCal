import Foundation

protocol FoodRepositoryProtocol {
    func fetchLog(for date: Date) async throws -> DailyLog
    func saveEntry(_ entry: FoodEntry, for date: Date) async throws
    func deleteEntry(id: UUID, for date: Date) async throws
    func fetchAllLibraryItems() async throws -> [FoodEntry]
    func saveToLibrary(_ entry: FoodEntry) async throws
    func deleteFromLibrary(id: UUID) async throws
}
