import Foundation

enum ProductType: String, CaseIterable, Codable {
    case lipstick = "Lipstick"
    case eyeshadow = "Eyeshadow"
    case nailPolish = "Nail Polish"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

enum ProductLabel: String, CaseIterable, Codable {
    case favorite = "favorite"
    case duplicate = "duplicate"
    case none = "none"
    
    var emoji: String {
        switch self {
        case .favorite:
            return "💖"
        case .duplicate:
            return "⚠️"
        case .none:
            return ""
        }
    }
    
    var displayName: String {
        switch self {
        case .favorite:
            return "Favorite"
        case .duplicate:
            return "Duplicate"
        case .none:
            return "None"
        }
    }
}

struct CosmeticProduct: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var type: ProductType
    var brand: String
    var color: String
    var label: ProductLabel
    var comment: String
    var dateAdded: Date
    
    init(name: String, type: ProductType, brand: String, color: String, label: ProductLabel = .none, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.type = type
        self.brand = brand
        self.color = color
        self.label = label
        self.comment = comment
        self.dateAdded = Date()
    }
}

struct FilterOptions {
    var selectedTypes: Set<ProductType> = []
    var brandFilter: String = ""
    var colorFilter: String = ""
    var selectedLabels: Set<ProductLabel> = []
    
    var isActive: Bool {
        return !selectedTypes.isEmpty || !brandFilter.isEmpty || !colorFilter.isEmpty || !selectedLabels.isEmpty
    }
    
    mutating func reset() {
        selectedTypes.removeAll()
        brandFilter = ""
        colorFilter = ""
        selectedLabels.removeAll()
    }
}

extension CosmeticProduct {
    func matches(filter: FilterOptions, searchText: String = "") -> Bool {
        if !filter.selectedTypes.isEmpty && !filter.selectedTypes.contains(type) {
            return false
        }
        
        if !filter.brandFilter.isEmpty && !brand.localizedCaseInsensitiveContains(filter.brandFilter) {
            return false
        }
        
        if !filter.colorFilter.isEmpty && !color.localizedCaseInsensitiveContains(filter.colorFilter) {
            return false
        }
        
        if !filter.selectedLabels.isEmpty && !filter.selectedLabels.contains(label) {
            return false
        }
        
        if !searchText.isEmpty {
            let searchLower = searchText.lowercased()
            return name.lowercased().contains(searchLower) ||
                   brand.lowercased().contains(searchLower) ||
                   color.lowercased().contains(searchLower) ||
                   type.rawValue.lowercased().contains(searchLower)
        }
        
        return true
    }
}
