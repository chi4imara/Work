import Foundation

enum BagScenario: String, CaseIterable, Identifiable, Codable {
    case day = "Day"
    case evening = "Evening" 
    case travel = "Travel"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .day:
            return "Day"
        case .evening:
            return "Evening"
        case .travel:
            return "Travel"
        }
    }
    
    var icon: String {
        switch self {
        case .day:
            return "sun.max"
        case .evening:
            return "moon.stars"
        case .travel:
            return "airplane"
        }
    }
}

struct Bag: Identifiable, Codable {
    let id: UUID
    var name: String
    var scenario: BagScenario
    var comment: String
    var isFavorite: Bool
    let createdAt: Date
    
    init(name: String, scenario: BagScenario, comment: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.scenario = scenario
        self.comment = comment
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }
    
    init(id: UUID, name: String, scenario: BagScenario, comment: String, isFavorite: Bool, createdAt: Date) {
        self.id = id
        self.name = name
        self.scenario = scenario
        self.comment = comment
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case scenarios = "Scenarios"
    case favorites = "Favorites"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .scenarios:
            return "list.bullet"
        case .favorites:
            return "heart"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .scenarios:
            return "list.bullet"
        case .favorites:
            return "heart.fill"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}
