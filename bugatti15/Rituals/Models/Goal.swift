import Foundation

enum GoalCategory: String, CaseIterable, Identifiable, Codable {
    case body = "body"
    case soul = "soul"
    case hobby = "hobby"
    case social = "social"
    case other = "other"
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .body: return "Body"
        case .soul: return "Soul"
        case .hobby: return "Hobby"
        case .social: return "Social"
        case .other: return "Other"
        }
    }
    
    var icon: String {
        switch self {
        case .body: return "figure.walk"
        case .soul: return "heart.fill"
        case .hobby: return "paintbrush.fill"
        case .social: return "person.2.fill"
        case .other: return "star.fill"
        }
    }
}

enum GoalFrequency: String, CaseIterable, Identifiable, Codable {
    case once = "once"
    case daily = "daily"
    case weekly = "weekly"
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .once: return "Once"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        }
    }
}

struct Goal: Identifiable, Codable {
    let id: UUID
    var title: String
    var category: GoalCategory
    var frequency: GoalFrequency
    var icon: String
    var description: String?
    var isCompleted: Bool
    var completionDates: [Date]
    var createdDate: Date
    var streak: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, category, frequency, icon, description
        case isCompleted, completionDates, createdDate, streak
    }
    
    init(id: UUID = UUID(), title: String, category: GoalCategory, frequency: GoalFrequency, icon: String? = nil, description: String? = nil, isCompleted: Bool = false, completionDates: [Date] = [], createdDate: Date = Date(), streak: Int = 0) {
        self.id = id
        self.title = title
        self.category = category
        self.frequency = frequency
        self.icon = icon ?? category.icon
        self.description = description
        self.isCompleted = isCompleted
        self.completionDates = completionDates
        self.createdDate = createdDate
        self.streak = streak
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(GoalCategory.self, forKey: .category)
        frequency = try container.decode(GoalFrequency.self, forKey: .frequency)
        icon = try container.decode(String.self, forKey: .icon)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false
        completionDates = try container.decodeIfPresent([Date].self, forKey: .completionDates) ?? []
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        streak = try container.decodeIfPresent(Int.self, forKey: .streak) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(category, forKey: .category)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(icon, forKey: .icon)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(completionDates, forKey: .completionDates)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(streak, forKey: .streak)
    }
    
    mutating func markCompleted() {
        isCompleted = true
        completionDates.append(Date())
        updateStreak()
    }
    
    mutating func markIncomplete() {
        isCompleted = false
        if let lastDate = completionDates.last, Calendar.current.isDateInToday(lastDate) {
            completionDates.removeLast()
        }
        updateStreak()
    }
    
    private mutating func updateStreak() {
        let calendar = Calendar.current
        let today = Date()
        var currentStreak = 0
        
        let sortedDates = completionDates.sorted(by: >)
        
        for date in sortedDates {
            let daysDifference = calendar.dateComponents([.day], from: date, to: today).day ?? 0
            
            if daysDifference == currentStreak {
                currentStreak += 1
            } else {
                break
            }
        }
        
        self.streak = currentStreak
    }
}
