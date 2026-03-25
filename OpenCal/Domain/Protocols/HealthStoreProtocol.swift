import Foundation

protocol HealthStoreProtocol {
    func requestPermissions() async throws
    func fetchActiveCaloriesBurned(for date: Date) async throws -> Double
    func fetchSteps(for date: Date) async throws -> Int
}
