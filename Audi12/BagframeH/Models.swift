import Foundation

struct Bag: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: BagType
    var description: String
    var items: [Item]
    var createdAt: Date
    
    init(name: String = "", type: BagType = .bag, description: String = "") {
        self.id = UUID()
        self.name = name
        self.type = type
        self.description = description
        self.items = []
        self.createdAt = Date()
    }
}

enum BagType: String, CaseIterable, Codable {
    case bag = "Bag"
    case backpack = "Backpack"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .bag:
            return "handbag"
        case .backpack:
            return "backpack"
        }
    }
}

struct Item: Identifiable, Codable {
    let id: UUID
    var name: String
    var createdAt: Date
    
    init(name: String = "") {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}

enum DayScenario: String, CaseIterable {
    case work = "Work Day"
    case meetings = "Meetings"
    case travel = "Travel"
    case casual = "Casual Day"
    case gym = "Gym"
    
    var icon: String {
        switch self {
        case .work:
            return "briefcase"
        case .meetings:
            return "person.2"
        case .travel:
            return "airplane"
        case .casual:
            return "house"
        case .gym:
            return "dumbbell"
        }
    }
}
