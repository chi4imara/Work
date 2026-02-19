import Foundation

enum EnergyType: String, CaseIterable, Codable {
    case energy = "Energy"
    case strength = "Strength"
    case concentration = "Concentration"
    case motivation = "Motivation"
    case confidence = "Confidence"
    case discipline = "Discipline"
    case mood = "Mood"
    
    var iconName: String {
        switch self {
        case .energy:
            return "bolt.fill"
        case .strength:
            return "dumbbell.fill"
        case .concentration:
            return "target"
        case .motivation:
            return "flame.fill"
        case .confidence:
            return "star.fill"
        case .discipline:
            return "shield.fill"
        case .mood:
            return "face.smiling.fill"
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
}

struct EnergyLevel: Identifiable, Codable {
    let id: UUID
    let type: EnergyType
    let level: Int
    let date: Date
    
    init(type: EnergyType, level: Int) {
        self.id = UUID()
        self.type = type
        self.level = max(1, min(5, level))
        self.date = Date()
    }
}

struct DailyEnergyRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    var energyLevels: [EnergyLevel]
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
        self.energyLevels = []
    }
    
    mutating func addEnergyLevel(_ energyLevel: EnergyLevel) {
        energyLevels.removeAll { $0.type == energyLevel.type }
        energyLevels.append(energyLevel)
    }
    
    func getEnergyLevel(for type: EnergyType) -> EnergyLevel? {
        return energyLevels.first { $0.type == type }
    }
    
    var averageEnergyLevel: Double {
        guard !energyLevels.isEmpty else { return 0 }
        let total = energyLevels.reduce(0) { $0 + $1.level }
        return Double(total) / Double(energyLevels.count)
    }
}
