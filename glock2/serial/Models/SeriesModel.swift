import Foundation

enum SeriesStatus: String, CaseIterable, Codable {
    case watching = "Watching Now"
    case waiting = "Waiting for New Seasons"
    
    var displayName: String {
        return self.rawValue
    }
}

enum SeriesCategory: String, CaseIterable, Codable {
    case drama = "Drama"
    case comedy = "Comedy"
    case sciFi = "Sci-Fi"
    case other = "Other"
    case custom = "Custom"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Series: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var category: SeriesCategory
    var customCategoryId: UUID?
    var status: SeriesStatus
    var dateAdded: Date
    
    init(title: String, description: String = "", category: SeriesCategory = .drama, customCategoryId: UUID? = nil, status: SeriesStatus = .watching) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.customCategoryId = customCategoryId
        self.status = status
        self.dateAdded = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, category, customCategoryId, status, dateAdded
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(SeriesCategory.self, forKey: .category)
        self.customCategoryId = try container.decodeIfPresent(UUID.self, forKey: .customCategoryId)
        self.status = try container.decode(SeriesStatus.self, forKey: .status)
        self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encodeIfPresent(customCategoryId, forKey: .customCategoryId)
        try container.encode(status, forKey: .status)
        try container.encode(dateAdded, forKey: .dateAdded)
    }
}
