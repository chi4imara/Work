import Foundation

enum ToolCategory: String, CaseIterable, Identifiable, Codable {
    case manual = "Manual"
    case electric = "Electric"
    case garden = "Garden"
    case measuring = "Measuring"
    case other = "Other"
    
    var id: String { self.rawValue }
}

struct UsageDate: Identifiable, Codable {
    let id: UUID
    let date: Date
    
    init(date: Date) {
        self.id = UUID()
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case id, date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct Tool: Identifiable, Codable {
    let id: UUID
    var name: String
    var storageLocation: String
    var category: ToolCategory
    var comment: String
    var usageDates: [UsageDate]
    
    init(name: String, storageLocation: String, category: ToolCategory, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.storageLocation = storageLocation
        self.category = category
        self.comment = comment
        self.usageDates = []
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, storageLocation, category, comment, usageDates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        storageLocation = try container.decode(String.self, forKey: .storageLocation)
        category = try container.decode(ToolCategory.self, forKey: .category)
        comment = try container.decode(String.self, forKey: .comment)
        usageDates = try container.decode([UsageDate].self, forKey: .usageDates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(storageLocation, forKey: .storageLocation)
        try container.encode(category, forKey: .category)
        try container.encode(comment, forKey: .comment)
        try container.encode(usageDates, forKey: .usageDates)
    }
    
    var usageCount: Int {
        return usageDates.count
    }
    
    var lastUsedDate: Date? {
        return usageDates.map { $0.date }.max()
    }
    
    mutating func addUsageDate(_ date: Date) {
        let usageDate = UsageDate(date: date)
        usageDates.append(usageDate)
        usageDates.sort { $0.date > $1.date }
    }
    
    mutating func removeUsageDate(withId id: UUID) {
        usageDates.removeAll { $0.id == id }
    }
}
