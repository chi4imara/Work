import Foundation

enum AccessoryType: String, CaseIterable, Identifiable, Codable {
    case glasses = "Glasses"
    case belt = "Belt"
    case gloves = "Gloves"
    case umbrella = "Umbrella"
    case other = "Other"
    
    var id: String { rawValue }
    
    var displayName: String {
        return rawValue
    }
}

enum AccessoryStatus: String, CaseIterable, Identifiable, Codable {
    case inUse = "In Use"
    case favorite = "Favorite"
    case inRepair = "In Repair"
    case lost = "Lost"
    
    var id: String { rawValue }
    
    var displayName: String {
        return rawValue
    }
}

struct Accessory: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: AccessoryType
    var status: AccessoryStatus
    var description: String
    var comment: String
    var dateCreated: Date
    
    init(name: String, type: AccessoryType, status: AccessoryStatus, description: String = "", comment: String = "") {
        self.id = UUID()
        self.name = name
        self.type = type
        self.status = status
        self.description = description
        self.comment = comment
        self.dateCreated = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case status
        case description
        case comment
        case dateCreated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(AccessoryType.self, forKey: .type)
        status = try container.decode(AccessoryStatus.self, forKey: .status)
        description = try container.decode(String.self, forKey: .description)
        comment = try container.decode(String.self, forKey: .comment)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(status, forKey: .status)
        try container.encode(description, forKey: .description)
        try container.encode(comment, forKey: .comment)
        try container.encode(dateCreated, forKey: .dateCreated)
    }
}
