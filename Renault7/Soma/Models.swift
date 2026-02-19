import Foundation

enum WellnessType: String, CaseIterable, Codable {
    case energy = "Energy"
    case tension = "Tension"
    case fatigue = "Fatigue"
}

struct WellnessState {
    let type: WellnessType
    var level: Int 
}

enum PracticeType: String, CaseIterable, Codable {
    case movement = "Movement"
    case rest = "Rest"
    case breathing = "Breathing"
    case recovery = "Recovery"
    
    var icon: String {
        switch self {
        case .movement: return "figure.walk"
        case .rest: return "bed.double"
        case .breathing: return "lungs"
        case .recovery: return "heart"
        }
    }
}

struct Practice: Identifiable, Codable {
    var id: UUID
    var name: String
    var type: PracticeType
    var duration: Int
    var streak: Int
    var lastCompleted: Date?
    var note: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, duration, streak, lastCompleted, note
    }
    
    init(id: UUID = UUID(), name: String, type: PracticeType, duration: Int, streak: Int = 0, lastCompleted: Date? = nil, note: String = "") {
        self.id = id
        self.name = name
        self.type = type
        self.duration = duration
        self.streak = streak
        self.lastCompleted = lastCompleted
        self.note = note
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? c.decode(UUID.self, forKey: .id)) ?? UUID()
        name = try c.decode(String.self, forKey: .name)
        type = try c.decode(PracticeType.self, forKey: .type)
        duration = try c.decode(Int.self, forKey: .duration)
        streak = (try? c.decode(Int.self, forKey: .streak)) ?? 0
        lastCompleted = try? c.decode(Date.self, forKey: .lastCompleted)
        note = (try? c.decode(String.self, forKey: .note)) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(type, forKey: .type)
        try c.encode(duration, forKey: .duration)
        try c.encode(streak, forKey: .streak)
        try c.encodeIfPresent(lastCompleted, forKey: .lastCompleted)
        try c.encode(note, forKey: .note)
    }
}

struct DailyChallenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted: Bool = false
    
    static let challenges = [
        DailyChallenge(title: "Stand and Stretch", description: "Stand up and stretch 3 times today"),
        DailyChallenge(title: "Screen Break", description: "Take 5 minutes without any screen"),
        DailyChallenge(title: "Mindful Walk", description: "Take a walk without any specific goal"),
        DailyChallenge(title: "Deep Breathing", description: "Practice 10 deep breaths"),
        DailyChallenge(title: "Body Check", description: "Notice how your body feels right now")
    ]
}

struct DailyPractice: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: String
    let type: PracticeType
    
    static let practices = [
        DailyPractice(title: "Gentle Stretching", description: "Soft movements to awaken your body", duration: "5 min", type: .movement),
        DailyPractice(title: "Breathing Space", description: "Calm breathing to center yourself", duration: "3 min", type: .breathing),
        DailyPractice(title: "Body Relaxation", description: "Release tension and find comfort", duration: "7 min", type: .recovery)
    ]
}

struct HistoryEntry: Identifiable, Codable {
    var id: UUID
    var date: Date
    var wellnessStates: [WellnessType: Int]
    var completedPractices: [String]
    var completedChallenges: [String]
    var careLevel: Double
    
    init(id: UUID = UUID(), date: Date, wellnessStates: [WellnessType: Int] = [:], completedPractices: [String] = [], completedChallenges: [String] = [], careLevel: Double = 0.0) {
        self.id = id
        self.date = date
        self.wellnessStates = wellnessStates
        self.completedPractices = completedPractices
        self.completedChallenges = completedChallenges
        self.careLevel = careLevel
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: HistoryEntry.CodingKeys.self)
        id = (try? c.decode(UUID.self, forKey: .id)) ?? UUID()
        date = try c.decode(Date.self, forKey: .date)
        wellnessStates = (try? c.decode([WellnessType: Int].self, forKey: .wellnessStates)) ?? [:]
        completedPractices = (try? c.decode([String].self, forKey: .completedPractices)) ?? []
        completedChallenges = (try? c.decode([String].self, forKey: .completedChallenges)) ?? []
        careLevel = (try? c.decode(Double.self, forKey: .careLevel)) ?? 0.0
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: HistoryEntry.CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(date, forKey: .date)
        try c.encode(wellnessStates, forKey: .wellnessStates)
        try c.encode(completedPractices, forKey: .completedPractices)
        try c.encode(completedChallenges, forKey: .completedChallenges)
        try c.encode(careLevel, forKey: .careLevel)
    }
}

extension HistoryEntry {
    enum CodingKeys: String, CodingKey {
        case id, date, wellnessStates, completedPractices, completedChallenges, careLevel
    }
}
