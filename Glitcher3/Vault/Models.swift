import Foundation

struct Gadget: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var category: String
    var purchaseDate: Date
    var price: String
    var condition: String
    var serviceLife: String
    var comment: String
    
    init(name: String = "", category: String = "", purchaseDate: Date = Date(), price: String = "", condition: String = "", serviceLife: String = "", comment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.purchaseDate = purchaseDate
        self.price = price
        self.condition = condition
        self.serviceLife = serviceLife
        self.comment = comment
    }
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let gadgets: [Gadget]
    
    var count: Int {
        return gadgets.count
    }
}

enum AppState {
    case splash
    case onboarding
    case main
}

enum TabItem: String, CaseIterable {
    case add = "Add"
    case catalog = "Catalog"
    case categories = "Categories"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .add:
            return "plus.circle"
        case .catalog:
            return "list.bullet"
        case .categories:
            return "folder"
        case .settings:
            return "gearshape"
        case .statistics:
            return "chart.bar"
        }
    }
}

enum NavigationDestination: Hashable {
    case gadgetSaved(Gadget)
    case gadgetDetails(Gadget)
    case editGadget(Gadget)
    case categoryGadgets(String, [Gadget])
}

extension String {
    static let commonCategories = [
        "Phone",
        "Laptop",
        "Headphones",
        "Watch",
        "Tablet",
        "Camera",
        "Gaming Console",
        "Smart TV",
        "Speaker",
        "Other"
    ]
}

struct GadgetIDWrapper: Identifiable {
    let id: UUID
}
