import Foundation

struct ScentEntry: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var associations: String
    var dateAdded: Date
    
    init(name: String, category: String = "", associations: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.associations = associations
        self.dateAdded = Date()
    }
}

enum ScentCategory: String, CaseIterable {
    case nature = "Nature"
    case home = "Home"
    case cafeFood = "Cafe / Food"
    case city = "City"
    case aromas = "Aromas"
    case custom = "Custom Category"
    
    var displayName: String {
        return self.rawValue
    }
}

enum SortOption: String, CaseIterable {
    case dateNewest = "By date added (newest first)"
    case alphabetical = "Alphabetically"
    case category = "By category"
    
    var displayName: String {
        return self.rawValue
    }
}
