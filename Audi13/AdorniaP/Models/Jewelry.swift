import Foundation

struct Jewelry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var type: JewelryType
    
    init(name: String = "", type: JewelryType = .ring) {
        self.id = UUID()
        self.name = name
        self.type = type
    }
}

enum JewelryType: String, CaseIterable, Codable {
    case ring = "Ring"
    case earrings = "Earrings"
    case bracelet = "Bracelet"
    case necklace = "Necklace"
    case watch = "Watch"
    case brooch = "Brooch"
    case anklet = "Anklet"
    case pendant = "Pendant"
    
    var displayName: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .ring:
            return "circle"
        case .earrings:
            return "ear"
        case .bracelet:
            return "watch.analog"
        case .necklace:
            return "link"
        case .watch:
            return "clock"
        case .brooch:
            return "star"
        case .anklet:
            return "figure.walk"
        case .pendant:
            return "heart"
        }
    }
}
