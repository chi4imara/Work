import Foundation

struct StorageLocation: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var icon: String
    var products: [Product] = []
    var createdAt: Date = Date()
    
    var productCount: Int {
        products.count
    }
}

struct Product: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: ProductCategory
    var brand: String
    var storageLocationId: UUID
    var expirationDate: Date?
    var notes: String
    var createdAt: Date = Date()
    var lastUsedDate: Date?
    var usageCount: Int = 0
    
    var isExpiringSoon: Bool {
        guard let expirationDate = expirationDate else { return false }
        let thirtyDaysFromNow = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        return expirationDate <= thirtyDaysFromNow
    }
    
    var isExpired: Bool {
        guard let expirationDate = expirationDate else { return false }
        return expirationDate <= Date()
    }
    
    var daysSinceLastUse: Int? {
        guard let lastUsed = lastUsedDate else { return nil }
        return Calendar.current.dateComponents([.day], from: lastUsed, to: Date()).day
    }
}

enum ProductCategory: String, CaseIterable, Codable {
    case lipstick = "Lipstick"
    case foundation = "Foundation"
    case eyeshadow = "Eyeshadow"
    case mascara = "Mascara"
    case blush = "Blush"
    case concealer = "Concealer"
    case bronzer = "Bronzer"
    case highlighter = "Highlighter"
    case eyeliner = "Eyeliner"
    case lipgloss = "Lip Gloss"
    case primer = "Primer"
    case powder = "Powder"
    case skincare = "Skincare"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

enum StorageIcon: String, CaseIterable {
    case basket = "basket.fill"
    case bag = "bag.fill"
    case briefcase = "briefcase.fill"
    case box = "shippingbox.fill"
    case drawer = "cabinet.fill"
    
    var displayName: String {
        switch self {
        case .basket: return "Basket"
        case .bag: return "Bag"
        case .briefcase: return "Briefcase"
        case .box: return "Box"
        case .drawer: return "Drawer"
        }
    }
}

enum ProductFilter: String, CaseIterable {
    case all = "All"
    case category = "By Category"
    case expiration = "By Expiration"
    case brand = "By Brand"
}
