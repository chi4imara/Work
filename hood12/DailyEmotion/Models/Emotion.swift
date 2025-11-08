import Foundation

enum EmotionType: String, CaseIterable, Codable {
    case joy = "joy"
    case calm = "calm"
    case tired = "tired"
    case angry = "angry"
    case bored = "bored"
    case success = "success"
    
    var icon: String {
        switch self {
        case .joy: return "face.smiling"
        case .calm: return "face.smiling.inverse"
        case .tired: return "zzz"
        case .angry: return "flame"
        case .bored: return "moon.zzz"
        case .success: return "star.fill"
        }
    }
    
    var title: String {
        switch self {
        case .joy: return "Joy"
        case .calm: return "Calm"
        case .tired: return "Tired"
        case .angry: return "Angry"
        case .bored: return "Bored"
        case .success: return "Success"
        }
    }
}

struct EmotionEntry: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var emotion: EmotionType
    var reason: String
    
    init(date: Date = Date(), emotion: EmotionType, reason: String) {
        self.date = date
        self.emotion = emotion
        self.reason = reason
    }
}
