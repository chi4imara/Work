import Foundation

struct MakeupIdea: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var tag: MakeupTag
    var comment: String
    let dateCreated: Date
    
    init(title: String, description: String, tag: MakeupTag, comment: String = "") {
        self.id = UUID()
        self.title = title
        self.description = description
        self.tag = tag
        self.comment = comment
        self.dateCreated = Date()
    }
    
    init(id: UUID, title: String, description: String, tag: MakeupTag, comment: String, dateCreated: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.tag = tag
        self.comment = comment
        self.dateCreated = dateCreated
    }
}

enum MakeupTag: String, CaseIterable, Codable {
    case evening = "Evening"
    case daily = "Daily"
    case special = "Special Occasion"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .evening:
            return "moon.stars"
        case .daily:
            return "sun.max"
        case .special:
            return "party.popper"
        }
    }
}

enum FilterType: String, CaseIterable {
    case all = "All"
    case evening = "Evening"
    case daily = "Daily"
    case special = "Special Occasion"
    
    var makeupTag: MakeupTag? {
        switch self {
        case .all:
            return nil
        case .evening:
            return .evening
        case .daily:
            return .daily
        case .special:
            return .special
        }
    }
}
