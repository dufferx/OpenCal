import Foundation

struct UserProfile: Codable, Equatable {
    let id: UUID
    let name: String
    let age: Int
    let heightCm: Double
    let weightKg: Double
    let dailyCalorieGoal: Double
    let dailyProteinGoal: Double
    let dailyCarbsGoal: Double
    let dailyFatGoal: Double
}

#if DEBUG
extension UserProfile {
    static var mock: UserProfile {
        UserProfile(
            id: UUID(),
            name: "Duglas Pineda",
            age: 25,
            heightCm: 175,
            weightKg: 70,
            dailyCalorieGoal: 1800,
            dailyProteinGoal: 150,
            dailyCarbsGoal: 150,
            dailyFatGoal: 65
        )
    }
}
#endif
