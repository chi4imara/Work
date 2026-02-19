import Foundation

enum ReactionType: String, CaseIterable, Identifiable, Codable {
    case movie = "Movie"
    case food = "Food"
    case place = "Place"
    case person = "Person"
    case other = "Other"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .movie: return "film"
        case .food: return "fork.knife"
        case .place: return "location"
        case .person: return "person"
        case .other: return "star"
        }
    }
    
    var color: String {
        switch self {
        case .movie: return "primaryBlue"
        case .food: return "accentOrange"
        case .place: return "accentGreen"
        case .person: return "accentPurple"
        case .other: return "primaryYellow"
        }
    }
}

struct Reaction: Identifiable, Codable, Equatable {
    let id: UUID
    var object: String
    var type: ReactionType
    var reaction: String
    var comment: String
    let createdAt: Date
    var updatedAt: Date
    
    init(object: String, type: ReactionType, reaction: String, comment: String = "") {
        self.id = UUID()
        self.object = object
        self.type = type
        self.reaction = reaction
        self.comment = comment
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func update(object: String, type: ReactionType, reaction: String, comment: String) {
        self.object = object
        self.type = type
        self.reaction = reaction
        self.comment = comment
        self.updatedAt = Date()
    }
}

struct ReactionStatistics {
    let totalCount: Int
    let movieCount: Int
    let foodCount: Int
    let placeCount: Int
    let personCount: Int
    let otherCount: Int
    
    init(reactions: [Reaction]) {
        self.totalCount = reactions.count
        self.movieCount = reactions.filter { $0.type == .movie }.count
        self.foodCount = reactions.filter { $0.type == .food }.count
        self.placeCount = reactions.filter { $0.type == .place }.count
        self.personCount = reactions.filter { $0.type == .person }.count
        self.otherCount = reactions.filter { $0.type == .other }.count
    }
    
    func count(for type: ReactionType) -> Int {
        switch type {
        case .movie: return movieCount
        case .food: return foodCount
        case .place: return placeCount
        case .person: return personCount
        case .other: return otherCount
        }
    }
}

enum TabItem: String, CaseIterable {
    case reactions = "Reactions"
    case categories = "Categories"
    case calendar = "Calendar"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .reactions: return "heart.text.square"
        case .categories: return "square.grid.2x2"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
        case .calendar: return "calendar"
        }
    }
}
