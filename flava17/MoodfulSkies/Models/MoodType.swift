import Foundation

enum MoodType: String, CaseIterable, Codable {
    case veryHappy = "very_happy"
    case happy = "happy"
    case neutral = "neutral"
    case sad = "sad"
    case angry = "angry"
    
    var icon: String {
        switch self {
        case .veryHappy:
            return "face.smiling"
        case .happy:
            return "face.smiling"
        case .neutral:
            return "minus.circle"
        case .sad:
            return "face.dashed"
        case .angry:
            return "exclamationmark.triangle"
        }
    }
    
    var displayName: String {
        switch self {
        case .veryHappy:
            return "Very Happy"
        case .happy:
            return "Happy"
        case .neutral:
            return "Neutral"
        case .sad:
            return "Sad"
        case .angry:
            return "Angry"
        }
    }
}
