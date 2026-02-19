import Foundation

struct Measurement: Identifiable, Codable {
    let id: UUID
    var date: Date
    var weight: Double
    var chest: Double
    var arms: Double
    var shoulders: Double
    var notes: String
    
    init(date: Date = Date(), weight: Double = 0, chest: Double = 0, arms: Double = 0, shoulders: Double = 0, notes: String = "") {
        self.id = UUID()
        self.date = date
        self.weight = weight
        self.chest = chest
        self.arms = arms
        self.shoulders = shoulders
        self.notes = notes
    }
}

enum BodyZone: String, CaseIterable {
    case weight = "Weight"
    case chest = "Chest"
    case arms = "Arms"
    case shoulders = "Shoulders"
    
    var unit: String {
        switch self {
        case .weight:
            return "kg"
        case .chest, .arms, .shoulders:
            return "cm"
        }
    }
    
    func getValue(from measurement: Measurement) -> Double {
        switch self {
        case .weight:
            return measurement.weight
        case .chest:
            return measurement.chest
        case .arms:
            return measurement.arms
        case .shoulders:
            return measurement.shoulders
        }
    }
}
