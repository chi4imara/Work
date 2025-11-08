import Foundation

struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var mood: MoodType
    var comment: String
    var photoIds: [String] = []
    
    var moodValue: Int {
        mood.rawValue
    }
}

enum MoodType: Int, CaseIterable, Codable {
    case veryBad = -2
    case bad = -1
    case neutral = 0
    case good = 1
    case veryGood = 2
    
    var emoji: String {
        switch self {
        case .veryBad: return "😢"
        case .bad: return "😟"
        case .neutral: return "😐"
        case .good: return "😊"
        case .veryGood: return "😀"
        }
    }
    
    var extendedEmoji: String {
        switch self {
        case .veryBad: return "😭"
        case .bad: return "😞"
        case .neutral: return "😐"
        case .good: return "😊"
        case .veryGood: return "🤩"
        }
    }
    
    var description: String {
        switch self {
        case .veryBad: return "Very Bad"
        case .bad: return "Bad"
        case .neutral: return "Neutral"
        case .good: return "Good"
        case .veryGood: return "Very Good"
        }
    }
}

extension MoodType {
    static var basicMoods: [MoodType] {
        [.veryBad, .bad, .neutral, .good, .veryGood]
    }
    
    static var extendedMoods: [MoodType] {
        [.veryBad, .bad, .neutral, .good, .veryGood]
    }
}
