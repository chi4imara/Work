import Foundation

struct MakeupLook: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: MakeupCategory
    var mainShades: [String]
    var applicationSteps: String
    var products: [String]
    var result: String
    var dateCreated: Date
    
    init(name: String, category: MakeupCategory, mainShades: [String] = [], applicationSteps: String = "", products: [String] = [], result: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.mainShades = mainShades
        self.applicationSteps = applicationSteps
        self.products = products
        self.result = result
        self.dateCreated = Date()
    }
}

enum MakeupCategory: String, CaseIterable, Codable {
    case daily = "Daily"
    case evening = "Evening"
    case festive = "Festive"
    
    var icon: String {
        switch self {
        case .daily: return "sun.max"
        case .evening: return "moon"
        case .festive: return "star"
        }
    }
}

struct Product: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ProductCategory
    var shade: String
    var comment: String
    var dateAdded: Date
    
    init(name: String, category: ProductCategory, shade: String = "", comment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.shade = shade
        self.comment = comment
        self.dateAdded = Date()
    }
}

enum ProductCategory: String, CaseIterable, Codable {
    case lips = "Lips"
    case eyes = "Eyes"
    case face = "Face"
    case brows = "Brows"
    case other = "Other"
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var dateCreated: Date
    var isPinned: Bool
    
    init(title: String, content: String, isPinned: Bool = false) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dateCreated = Date()
        self.isPinned = isPinned
    }
}

enum TabItem: String, CaseIterable {
    case looks = "Looks"
    case products = "Products"
    case notes = "Notes"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .looks: return "paintbrush"
        case .products: return "bag"
        case .notes: return "note.text"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
        }
    }
}
