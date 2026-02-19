import Foundation

enum TaskFrequency: String, CaseIterable, Identifiable, Codable {
    case once = "Once"
    case daily = "Daily"
    case weekly = "Several times a week"
    
    var id: String { self.rawValue }
}

struct DailyTask: Identifiable, Codable {
    let id: UUID
    var title: String
    var category: PlaceCategory
    var frequency: TaskFrequency
    var isCompleted: Bool
    var completionDate: Date?
    var whyImportant: String?
    
    init(title: String, category: PlaceCategory, frequency: TaskFrequency = .once, whyImportant: String? = nil) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.frequency = frequency
        self.isCompleted = false
        self.whyImportant = whyImportant
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(PlaceCategory.self, forKey: .category)
        frequency = try container.decode(TaskFrequency.self, forKey: .frequency)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        completionDate = try container.decodeIfPresent(Date.self, forKey: .completionDate)
        whyImportant = try container.decodeIfPresent(String.self, forKey: .whyImportant)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(category, forKey: .category)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(completionDate, forKey: .completionDate)
        try container.encodeIfPresent(whyImportant, forKey: .whyImportant)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, category, frequency, isCompleted, completionDate, whyImportant
    }
}

struct MiniChallenge: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var completionDate: Date?
    
    init(title: String, description: String) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isCompleted = false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        completionDate = try container.decodeIfPresent(Date.self, forKey: .completionDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(completionDate, forKey: .completionDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, isCompleted, completionDate
    }
    
    static let dailyChallenges = [
        MiniChallenge(title: "Take a sunset photo", description: "Capture the beauty of today's sunset"),
        MiniChallenge(title: "Walk for 30 minutes", description: "Take a refreshing 30-minute walk"),
        MiniChallenge(title: "Visit a new street", description: "Explore a street you've never been to"),
        MiniChallenge(title: "Try a new cafe", description: "Discover a cozy new place for coffee"),
        MiniChallenge(title: "Take 5 photos of nature", description: "Find beauty in nature around you")
    ]
}
