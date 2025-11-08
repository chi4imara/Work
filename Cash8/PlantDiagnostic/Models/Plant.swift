import Foundation

struct Plant: Identifiable, Codable {
    let id: String
    let name: String
    let latinName: String?
    let type: PlantType
    let difficulty: Difficulty
    let imageName: String?
    let watering: WateringInfo
    let repotting: RepottingInfo
    let fertilizing: FertilizingInfo
    let lighting: LightingInfo
    let temperature: TemperatureInfo
    let diseases: [DiseaseInfo]
    let funFacts: [String]
    
    enum PlantType: String, CaseIterable, Codable {
        case indoor = "Indoor"
        case outdoor = "Outdoor"
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

struct WateringInfo: Codable {
    let frequency: String
    let amount: String
    let notes: String
}

struct RepottingInfo: Codable {
    let timing: String
    let soilType: String
    let potRecommendations: String
    let signs: String
}

struct FertilizingInfo: Codable {
    let type: String
    let frequency: String
    let warnings: String
}

struct LightingInfo: Codable {
    let preference: String
    let directSun: Bool
    let distance: String
}

struct TemperatureInfo: Codable {
    let range: String
    let humidity: String
    let drafts: String
}

struct DiseaseInfo: Codable {
    let name: String
    let symptoms: String
    let treatment: String
}

