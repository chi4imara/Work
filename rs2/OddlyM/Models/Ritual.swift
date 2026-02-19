import Foundation

struct Ritual: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isRepeating: Bool
    var completionDates: [Date]
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, isRepeating
        case completionDates
    }
    
    init(id: UUID = UUID(), title: String, description: String, isRepeating: Bool = false, completionDates: [Date] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.isRepeating = isRepeating
        self.completionDates = completionDates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isRepeating = try container.decode(Bool.self, forKey: .isRepeating)
        let timeIntervals = try container.decode([TimeInterval].self, forKey: .completionDates)
        completionDates = timeIntervals.map { Date(timeIntervalSince1970: $0) }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(isRepeating, forKey: .isRepeating)
        let timeIntervals = completionDates.map { $0.timeIntervalSince1970 }
        try container.encode(timeIntervals, forKey: .completionDates)
    }
    
    var shortDescription: String {
        description.components(separatedBy: .newlines).first ?? description
    }
    
    var completionCount: Int {
        completionDates.count
    }
    
    func isCompletedToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return completionDates.contains { date in
            Calendar.current.startOfDay(for: date) == today
        }
    }
}
