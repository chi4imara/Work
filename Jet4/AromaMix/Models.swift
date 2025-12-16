import Foundation
import Combine

struct ScentCombination: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ScentCategory
    var perfumeAroma: String
    var candleAroma: String
    var comment: String
    var rating: Rating
    var dateCreated: Date
    
    init(name: String, category: ScentCategory, perfumeAroma: String, candleAroma: String, comment: String = "", rating: Rating) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.perfumeAroma = perfumeAroma
        self.candleAroma = candleAroma
        self.comment = comment
        self.rating = rating
        self.dateCreated = Date()
    }
}

enum ScentCategory: String, CaseIterable, Codable {
    case warm = "Warm"
    case fresh = "Fresh"
    case floral = "Floral"
    case sweet = "Sweet"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .warm: return "flame"
        case .fresh: return "wind"
        case .floral: return "leaf"
        case .sweet: return "heart"
        case .other: return "sparkles"
        }
    }
}

enum Rating: String, CaseIterable, Codable {
    case favorite = "Favorite"
    case good = "Good"
    case trial = "Trial"
    
    var displayName: String {
        return self.rawValue
    }
    
    var color: String {
        switch self {
        case .favorite: return "red"
        case .good: return "green"
        case .trial: return "yellow"
        }
    }
    
    var icon: String {
        switch self {
        case .favorite: return "heart.fill"
        case .good: return "hand.thumbsup.fill"
        case .trial: return "questionmark.circle.fill"
        }
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var dateCreated: Date
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dateCreated = Date()
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        } else {
            let index = content.index(content.startIndex, offsetBy: maxLength)
            return String(content[..<index]) + "..."
        }
    }
}

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var isLoading: Bool = true
    
    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    func finishLoading() {
        isLoading = false
    }
}

enum TabSelection: String, CaseIterable {
    case combinations = "Combinations"
    case categories = "Categories"
    case notes = "Notes"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .combinations: return "heart.circle"
        case .categories: return "list.bullet.circle"
        case .notes: return "note.text"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .combinations: return "heart.circle.fill"
        case .categories: return "list.bullet.circle.fill"
        case .notes: return "note.text"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
