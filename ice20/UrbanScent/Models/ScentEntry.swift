import Foundation

struct ScentEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var scent: String
    var location: String
    var emotion: Emotion
    var comment: String?
    
    init(date: Date = Date(), scent: String, location: String, emotion: Emotion, comment: String? = nil) {
        self.date = date
        self.scent = scent
        self.location = location
        self.emotion = emotion
        self.comment = comment
    }
}

enum Emotion: String, CaseIterable, Codable {
    case calm = "Calm"
    case cozy = "Cozy"
    case sad = "Sad"
    case energetic = "Energetic"
    case fresh = "Fresh"
    
    var icon: String {
        switch self {
        case .calm:
            return "leaf"
        case .cozy:
            return "cup.and.saucer"
        case .sad:
            return "cloud.rain"
        case .energetic:
            return "flame"
        case .fresh:
            return "wind"
        }
    }
    
    var color: String {
        switch self {
        case .calm:
            return "green"
        case .cozy:
            return "yellow"
        case .sad:
            return "blue"
        case .energetic:
            return "red"
        case .fresh:
            return "cyan"
        }
    }
}
