import Foundation

struct UserProfile: Codable, Equatable {
    let id: UUID
    let name: String
    let birthDate: Date
    let biologicalSex: BiologicalSex
    let apiProvider: AIProvider
    let heightCm: Double
    let weightKg: Double
    let dailyCalorieGoal: Double
    let dailyProteinGoal: Double
    let dailyCarbsGoal: Double
    let dailyFatGoal: Double

    var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }

    init(
        id: UUID,
        name: String,
        birthDate: Date,
        biologicalSex: BiologicalSex,
        apiProvider: AIProvider,
        heightCm: Double,
        weightKg: Double,
        dailyCalorieGoal: Double,
        dailyProteinGoal: Double,
        dailyCarbsGoal: Double,
        dailyFatGoal: Double
    ) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.biologicalSex = biologicalSex
        self.apiProvider = apiProvider
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.dailyCalorieGoal = dailyCalorieGoal
        self.dailyProteinGoal = dailyProteinGoal
        self.dailyCarbsGoal = dailyCarbsGoal
        self.dailyFatGoal = dailyFatGoal
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        birthDate = try container.decodeIfPresent(Date.self, forKey: .birthDate)
            ?? Calendar.current.date(byAdding: .year, value: -AppConstants.Defaults.ageOffset, to: Date())
            ?? Date()
        biologicalSex = try container.decodeIfPresent(BiologicalSex.self, forKey: .biologicalSex)
            ?? .male
        apiProvider = try container.decodeIfPresent(AIProvider.self, forKey: .apiProvider)
            ?? .openAI
        heightCm = try container.decode(Double.self, forKey: .heightCm)
        weightKg = try container.decode(Double.self, forKey: .weightKg)
        dailyCalorieGoal = try container.decode(Double.self, forKey: .dailyCalorieGoal)
        dailyProteinGoal = try container.decode(Double.self, forKey: .dailyProteinGoal)
        dailyCarbsGoal = try container.decode(Double.self, forKey: .dailyCarbsGoal)
        dailyFatGoal = try container.decode(Double.self, forKey: .dailyFatGoal)
    }
}

#if DEBUG
extension UserProfile {
    static var mock: UserProfile {
        UserProfile(
            id: UUID(),
            name: "Duglas Pineda",
            birthDate: Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date(),
            biologicalSex: .male,
            apiProvider: .openAI,
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
