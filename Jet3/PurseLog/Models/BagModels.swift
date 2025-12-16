import Foundation

enum BagStyle: String, CaseIterable, Identifiable, Codable {
    case everyday = "Everyday"
    case evening = "Evening"
    case travel = "Travel"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .everyday:
            return "Everyday"
        case .evening:
            return "Evening"
        case .travel:
            return "Travel"
        case .other:
            return "Other"
        }
    }
}

enum UsageFrequency: String, CaseIterable, Identifiable, Codable {
    case often = "Often"
    case sometimes = "Sometimes"
    case rarely = "Rarely"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .often:
            return "Often"
        case .sometimes:
            return "Sometimes"
        case .rarely:
            return "Rarely"
        }
    }
}

struct Bag: Identifiable, Codable {
    let id: UUID
    var name: String
    var brand: String
    var style: BagStyle
    var color: String
    var usageFrequency: UsageFrequency
    var comment: String
    var isFavorite: Bool
    var lastUsedDate: Date?
    let dateCreated: Date
    
    init(name: String, brand: String, style: BagStyle, color: String, usageFrequency: UsageFrequency, comment: String = "", isFavorite: Bool = false, lastUsedDate: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.style = style
        self.color = color
        self.usageFrequency = usageFrequency
        self.comment = comment
        self.isFavorite = isFavorite
        self.lastUsedDate = lastUsedDate
        self.dateCreated = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case brand
        case style
        case color
        case usageFrequency
        case comment
        case isFavorite
        case lastUsedDate
        case dateCreated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        id = UUID(uuidString: idString) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        brand = try container.decode(String.self, forKey: .brand)
        style = try container.decode(BagStyle.self, forKey: .style)
        color = try container.decode(String.self, forKey: .color)
        usageFrequency = try container.decode(UsageFrequency.self, forKey: .usageFrequency)
        comment = try container.decode(String.self, forKey: .comment)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        if let lastUsedInterval = try container.decodeIfPresent(Double.self, forKey: .lastUsedDate) {
            lastUsedDate = Date(timeIntervalSince1970: lastUsedInterval)
        } else {
            lastUsedDate = nil
        }
        let dateTimeInterval = try container.decode(Double.self, forKey: .dateCreated)
        dateCreated = Date(timeIntervalSince1970: dateTimeInterval)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(brand, forKey: .brand)
        try container.encode(style, forKey: .style)
        try container.encode(color, forKey: .color)
        try container.encode(usageFrequency, forKey: .usageFrequency)
        try container.encode(comment, forKey: .comment)
        try container.encode(isFavorite, forKey: .isFavorite)
        if let lastUsedDate = lastUsedDate {
            try container.encode(lastUsedDate.timeIntervalSince1970, forKey: .lastUsedDate)
        }
        try container.encode(dateCreated.timeIntervalSince1970, forKey: .dateCreated)
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    let dateCreated: Date
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dateCreated = Date()
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        return String(content.prefix(maxLength)) + "..."
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case dateCreated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        id = UUID(uuidString: idString) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        let dateTimeInterval = try container.decode(Double.self, forKey: .dateCreated)
        dateCreated = Date(timeIntervalSince1970: dateTimeInterval)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(dateCreated.timeIntervalSince1970, forKey: .dateCreated)
    }
}

struct BagStatistics {
    let styleStats: [BagStyle: Int]
    let usageStats: [UsageFrequency: Int]
    let totalBags: Int
    
    var recommendation: String {
        let mostUsedStyle = styleStats.max(by: { $0.value < $1.value })?.key
        let leastUsedStyle = styleStats.min(by: { $0.value < $1.value })?.key
        
        if totalBags == 0 {
            return "No data for analysis. Add at least one bag to your collection."
        }
        
        if let most = mostUsedStyle, let least = leastUsedStyle, most != least {
            return "Your most used bags are \(most.displayName.lowercased()). Perhaps it's time to update your \(least.displayName.lowercased()) collection."
        }
        
        return "Your collection looks well balanced across different styles."
    }
}
