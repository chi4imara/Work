import Foundation

struct Challenge: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var categoryId: UUID
    var createdAt: Date
    var isFavorite: Bool = false
    
    init(text: String, categoryId: UUID) {
        self.id = UUID()
        self.text = text
        self.categoryId = categoryId
        self.createdAt = Date()
    }
}

struct Category: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}

struct HistoryEntry: Identifiable, Codable {
    let id: UUID
    let challengeId: UUID
    let challengeText: String
    let categoryName: String
    let generatedAt: Date
    
    init(challenge: Challenge, categoryName: String) {
        self.id = UUID()
        self.challengeId = challenge.id
        self.challengeText = challenge.text
        self.categoryName = categoryName
        self.generatedAt = Date()
    }
}

enum AppState {
    case onboarding
    case main
}

enum TabSelection: CaseIterable {
    case challenges
    case categories
    case create
    case favorites
    case settings
    
    var title: String {
        switch self {
        case .challenges: return "Challenge"
        case .categories: return "Categories"
        case .create: return "Create"
        case .favorites: return "Favorites"
        case .settings: return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .challenges: return "dice"
        case .categories: return "folder"
        case .create: return "plus.circle"
        case .favorites: return "star"
        case .settings: return "gearshape"
        }
    }
}
