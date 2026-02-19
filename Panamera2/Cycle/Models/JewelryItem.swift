import Foundation

struct JewelryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: JewelryCategory
    var customCategoryName: String?
    var description: String
    var lastWornDate: Date?
    
    init(name: String, category: JewelryCategory, description: String, customCategoryName: String? = nil, lastWornDate: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.customCategoryName = customCategoryName
        self.description = description
        self.lastWornDate = lastWornDate
    }
    
    var displayCategory: String {
        if category == .custom, let customName = customCategoryName {
            return customName
        }
        return category.displayName
    }
    
    var lastWornText: String {
        if let date = lastWornDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "Wore: \(formatter.string(from: date))"
        } else {
            return "Never worn"
        }
    }
    
    var hasBeenWorn: Bool {
        return lastWornDate != nil
    }
}

enum JewelryCategory: String, CaseIterable, Codable {
    case earrings = "Earrings"
    case bracelets = "Bracelets"
    case rings = "Rings"
    case necklaces = "Necklaces"
    case custom = "Custom"
    
    var displayName: String {
        return self.rawValue
    }
}

struct CustomCategory: Identifiable, Codable {
    let id = UUID()
    var name: String
}
