import Foundation

struct CustomCategory: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var color: String
    var dateCreated: Date
    
    init(name: String, icon: String = "tv", color: String = "primaryBlue") {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.color = color
        self.dateCreated = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon, color, dateCreated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.color = try container.decode(String.self, forKey: .color)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(color, forKey: .color)
        try container.encode(dateCreated, forKey: .dateCreated)
    }
}
