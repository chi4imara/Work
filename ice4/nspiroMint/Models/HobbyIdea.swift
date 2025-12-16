import Foundation

struct HobbyIdea: Identifiable, Codable, Equatable {
    let id: UUID
    var hobby: HobbyCategory
    var title: String
    var description: String
    var mood: String
    var dateCreated: Date
    var isFavorite: Bool = false
    
    init(hobby: HobbyCategory, title: String, description: String, mood: String, dateCreated: Date = Date()) {
        self.id = UUID()
        self.hobby = hobby
        self.title = title
        self.description = description
        self.mood = mood
        self.dateCreated = dateCreated
    }
}

enum HobbyCategory: String, CaseIterable, Codable {
    case drawing = "Drawing"
    case music = "Music"
    case sculpting = "Sculpting"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .drawing:
            return "paintbrush"
        case .music:
            return "music.note"
        case .sculpting:
            return "cube"
        case .other:
            return "star"
        }
    }
}
