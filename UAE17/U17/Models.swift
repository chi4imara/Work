import Foundation

enum ToolCategory: String, CaseIterable, Identifiable, Codable {
    case manual = "Manual"
    case electric = "Electric"
    case measuring = "Measuring"
    case automotive = "Automotive"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return self.rawValue
    }
}

struct Tool: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ToolCategory
    var storageLocation: String
    var lastUsedDate: Date
    var comment: String
    var createdDate: Date
    
    init(name: String, category: ToolCategory, storageLocation: String, lastUsedDate: Date = Date(), comment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.storageLocation = storageLocation
        self.lastUsedDate = lastUsedDate
        self.comment = comment
        self.createdDate = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, storageLocation, lastUsedDate, comment, createdDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(ToolCategory.self, forKey: .category)
        self.storageLocation = try container.decode(String.self, forKey: .storageLocation)
        self.lastUsedDate = try container.decode(Date.self, forKey: .lastUsedDate)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.createdDate = try container.decode(Date.self, forKey: .createdDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(storageLocation, forKey: .storageLocation)
        try container.encode(lastUsedDate, forKey: .lastUsedDate)
        try container.encode(comment, forKey: .comment)
        try container.encode(createdDate, forKey: .createdDate)
    }
}

struct Usage: Identifiable, Codable {
    let id: UUID
    let toolId: UUID
    let date: Date
    let toolName: String
    
    init(toolId: UUID, toolName: String, date: Date = Date()) {
        self.id = UUID()
        self.toolId = toolId
        self.toolName = toolName
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case id, toolId, date, toolName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString) ?? UUID()
        let toolIdString = try container.decode(String.self, forKey: .toolId)
        self.toolId = UUID(uuidString: toolIdString) ?? UUID()
        self.date = try container.decode(Date.self, forKey: .date)
        self.toolName = try container.decode(String.self, forKey: .toolName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(toolId.uuidString, forKey: .toolId)
        try container.encode(date, forKey: .date)
        try container.encode(toolName, forKey: .toolName)
    }
}

struct StatisticsData {
    let totalTools: Int
    let categoryStats: [ToolCategory: Int]
    let unusedTools: [Tool]
    let usageHistory: [Usage]
    
    init(tools: [Tool], usages: [Usage]) {
        self.totalTools = tools.count
        
        var categoryCount: [ToolCategory: Int] = [:]
        for category in ToolCategory.allCases {
            categoryCount[category] = tools.filter { $0.category == category }.count
        }
        self.categoryStats = categoryCount
        
        let sixtyDaysAgo = Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date()
        self.unusedTools = tools.filter { $0.lastUsedDate < sixtyDaysAgo }
        
        self.usageHistory = usages
    }
}
