import Foundation

struct Product: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: ProductCategory
    var volume: String
    var expirationDate: Date
    var status: ProductStatus
    var note: String
    var cosmeticBagId: UUID
    
    init(name: String, category: ProductCategory, volume: String, expirationDate: Date, status: ProductStatus, note: String = "", cosmeticBagId: UUID) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.volume = volume
        self.expirationDate = expirationDate
        self.status = status
        self.note = note
        self.cosmeticBagId = cosmeticBagId
    }
}

enum ProductCategory: String, CaseIterable, Codable {
    case skincare = "Skincare"
    case makeup = "Makeup"
    case fragrance = "Fragrance"
    
    var displayName: String {
        switch self {
        case .skincare:
            return "Skincare"
        case .makeup:
            return "Makeup"
        case .fragrance:
            return "Fragrance"
        }
    }
}

enum ProductStatus: String, CaseIterable, Codable {
    case available = "Available"
    case outOfStock = "Out of Stock"
    
    var displayName: String {
        switch self {
        case .available:
            return "Available"
        case .outOfStock:
            return "Out of Stock"
        }
    }
    
    var icon: String {
        switch self {
        case .available:
            return "checkmark.circle.fill"
        case .outOfStock:
            return "xmark.circle.fill"
        }
    }
}
