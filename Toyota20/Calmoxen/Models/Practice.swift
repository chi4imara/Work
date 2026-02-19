import Foundation

enum PracticeType: String, CaseIterable, Codable {
    case breathing = "Breathing Exercises"
    case stretching = "Stretching"
    case meditation = "Meditation"
    case exercise = "Short Exercise"
    
    var icon: String {
        switch self {
        case .breathing: return "wind"
        case .stretching: return "figure.flexibility"
        case .meditation: return "brain.head.profile"
        case .exercise: return "figure.walk"
        }
    }
}

enum Frequency: String, CaseIterable, Codable {
    case once = "Once"
    case daily = "Daily"
    case severalTimesWeek = "Several times a week"
}

struct Practice: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var type: PracticeType
    var duration: Int
    var frequency: Frequency
    var comment: String
    var isFavorite: Bool
    var createdAt: Date
    
    init(name: String, type: PracticeType, duration: Int, frequency: Frequency, comment: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.duration = duration
        self.frequency = frequency
        self.comment = comment
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }
}

extension Practice {
    static let samplePractices = [
        Practice(name: "Deep Breathing", type: .breathing, duration: 5, frequency: .daily),
        Practice(name: "Evening Stretch", type: .stretching, duration: 10, frequency: .daily),
        Practice(name: "Mindful Meditation", type: .meditation, duration: 15, frequency: .severalTimesWeek),
        Practice(name: "Light Movement", type: .exercise, duration: 8, frequency: .daily),
        Practice(name: "Progressive Relaxation", type: .breathing, duration: 12, frequency: .severalTimesWeek)
    ]
}
