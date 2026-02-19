import Foundation

enum PhaseType: String, CaseIterable, Identifiable, Codable {
    case mass = "Mass"
    case strength = "Strength"
    case endurance = "Endurance"
    case other = "Other"
    
    var id: String { self.rawValue }
}

struct Phase: Identifiable, Codable {
    let id: UUID
    var name: PhaseType
    var startDate: Date
    var comment: String
    var workouts: [Workout] = []
    
    init(name: PhaseType, startDate: Date, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.comment = comment
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case startDate
        case comment
        case workouts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let idString = try? container.decode(String.self, forKey: .id),
           let uuid = UUID(uuidString: idString) {
            self.id = uuid
        } else {
            self.id = UUID()
        }
        
        self.name = try container.decode(PhaseType.self, forKey: .name)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.workouts = try container.decodeIfPresent([Workout].self, forKey: .workouts) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(comment, forKey: .comment)
        try container.encode(workouts, forKey: .workouts)
    }
}
