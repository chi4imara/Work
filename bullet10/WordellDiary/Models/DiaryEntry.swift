import Foundation

enum Mood: String, CaseIterable, Codable {
    case happy = "happy"
    case neutral = "neutral" 
    case sad = "sad"
    case love = "love"
    case angry = "angry"
    
    var icon: String {
        switch self {
        case .happy: return "face.smiling"
        case .neutral: return "face.dashed"
        case .sad: return "face.dashed.fill"
        case .love: return "heart.fill"
        case .angry: return "flame.fill"
        }
    }
    
    var displayName: String {
        switch self {
        case .happy: return "Happy"
        case .neutral: return "Neutral"
        case .sad: return "Sad"
        case .love: return "Love"
        case .angry: return "Angry"
        }
    }
}

struct DiaryEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var mood: Mood
    var text: String
    var shortTitle: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(date: Date, mood: Mood, text: String, shortTitle: String? = nil) {
        self.id = UUID()
        self.date = date
        self.mood = mood
        self.text = text
        self.shortTitle = shortTitle
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var previewTitle: String {
        if let shortTitle = shortTitle, !shortTitle.isEmpty {
            return String(shortTitle.prefix(40))
        }
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        let preview = words.prefix(8).joined(separator: " ")
        return String(preview.prefix(40))
    }
    
    var previewText: String {
        let lines = text.components(separatedBy: .newlines)
        let firstTwoLines = lines.prefix(2).joined(separator: "\n")
        return String(firstTwoLines.prefix(80)) + (firstTwoLines.count > 80 ? "..." : "")
    }
    
    var characterCount: Int {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).count
    }
}

struct CustomTheme: Identifiable, Codable {
    let id: UUID
    var text: String
    var createdAt: Date
    var updatedAt: Date
    
    init(text: String) {
        self.id = UUID()
        self.text = text
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
