import Foundation

struct ShoppingItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var quantity: String
    var comment: String
    var dateCreated: Date
    
    init(name: String, category: String, quantity: String, comment: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.quantity = quantity
        self.comment = comment
        self.dateCreated = Date()
    }
    
    init(id: UUID, name: String, category: String, quantity: String, comment: String, dateCreated: Date) {
        self.id = id
        self.name = name
        self.category = category
        self.quantity = quantity
        self.comment = comment
        self.dateCreated = dateCreated
    }
}

struct Category: Identifiable {
    let id: UUID
    let name: String
    let itemCount: Int
    let items: [ShoppingItem]
    
    init(name: String, items: [ShoppingItem]) {
        self.id = UUID()
        self.name = name
        self.items = items
        self.itemCount = items.count
    }
}

enum AppState {
    case splash
    case onboarding
    case main
}

enum TabSelection: Int, CaseIterable {
    case add = 0
    case list = 1
    case categories = 2
    case statistics = 3
    case settings = 4
    
    var title: String {
        switch self {
        case .add:
            return "Add"
        case .list:
            return "List"
        case .categories:
            return "Categories"
        case .statistics:
            return "Statistics"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .add:
            return "plus.circle"
        case .list:
            return "list.bullet"
        case .categories:
            return "folder"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
}
