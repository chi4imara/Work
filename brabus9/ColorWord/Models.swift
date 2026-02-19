import Foundation

struct CatalogItem: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    let dateCreated: Date
    var dateModified: Date
    
    init(text: String) {
        self.id = UUID()
        self.text = text
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func updateText(_ newText: String) {
        self.text = newText
        self.dateModified = Date()
    }
}

enum TabItem: String, CaseIterable {
    case catalog = "Catalog"
    case random = "Random"
    case calendar = "Calendar"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var title: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .catalog:
            return "list.bullet"
        case .random:
            return "shuffle"
        case .calendar:
            return "calendar"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String?
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let action: SettingsAction
}

enum SettingsAction {
    case privacyPolicy
    case contactEmail
    case rateApp
}
