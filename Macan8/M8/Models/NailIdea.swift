import Foundation

enum IdeaStatus: String, CaseIterable, Codable {
    case inspiration = "Inspiration"
    case tryIt = "Try It"
    case done = "Done"
    
    var icon: String {
        switch self {
        case .inspiration:
            return "lightbulb"
        case .tryIt:
            return "star"
        case .done:
            return "checkmark.circle"
        }
    }
}

enum DesignType: String, CaseIterable, Codable {
    case french = "French"
    case gradient = "Gradient"
    case geometry = "Geometry"
    case minimalism = "Minimalism"
    case abstract = "Abstract"
}

enum SeasonEvent: String, CaseIterable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    case wedding = "Wedding"
    case vacation = "Vacation"
    case newYear = "New Year"
    case party = "Party"
}

struct NailIdea: Identifiable, Codable {
    let id: UUID
    var name: String
    var mainColor: String
    var additionalColors: String
    var designType: DesignType
    var seasonEvent: SeasonEvent
    var comment: String
    var status: IdeaStatus
    var dateAdded: Date
    
    init(name: String, mainColor: String, additionalColors: String = "", designType: DesignType, seasonEvent: SeasonEvent, comment: String = "", status: IdeaStatus = .inspiration) {
        self.id = UUID()
        self.name = name
        self.mainColor = mainColor
        self.additionalColors = additionalColors
        self.designType = designType
        self.seasonEvent = seasonEvent
        self.comment = comment
        self.status = status
        self.dateAdded = Date()
    }
}

struct NailCollection: Identifiable, Codable {
    let id: UUID
    var name: String
    var ideaIds: [UUID]
    var dateCreated: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.ideaIds = []
        self.dateCreated = Date()
    }
}
