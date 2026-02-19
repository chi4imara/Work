import Foundation

enum MoodType: String, CaseIterable, Identifiable, Codable {
    case happy = "😊"
    case excited = "🤗"
    case calm = "😌"
    case sad = "😢"
    case anxious = "😰"
    case angry = "😠"
    case tired = "😴"
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .happy: return "Happy"
        case .excited: return "Excited"
        case .calm: return "Calm"
        case .sad: return "Sad"
        case .anxious: return "Anxious"
        case .angry: return "Angry"
        case .tired: return "Tired"
        }
    }
}

struct Mood: Identifiable, Codable {
    let id: UUID
    let type: MoodType
    let intensity: Int
    let date: Date
    let note: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, intensity, date, note
    }
    
    init(id: UUID = UUID(), type: MoodType, intensity: Int = 3, date: Date = Date(), note: String? = nil) {
        self.id = id
        self.type = type
        self.intensity = intensity
        self.date = date
        self.note = note
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(MoodType.self, forKey: .type)
        intensity = try container.decode(Int.self, forKey: .intensity)
        date = try container.decode(Date.self, forKey: .date)
        note = try container.decodeIfPresent(String.self, forKey: .note)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(intensity, forKey: .intensity)
        try container.encode(date, forKey: .date)
        try container.encodeIfPresent(note, forKey: .note)
    }
}
