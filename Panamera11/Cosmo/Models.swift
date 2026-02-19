import Foundation
import SwiftUI

enum Texture: String, CaseIterable, Codable {
    case creamy = "Creamy"
    case liquid = "Liquid"
    case dry = "Dry"
    case powder = "Powder"
    case gel = "Gel"
    case matte = "Matte"
    case glossy = "Glossy"
    
    var displayName: String {
        return self.rawValue
    }
}

enum ProductType: String, CaseIterable, Codable {
    case foundation = "Foundation"
    case concealer = "Concealer"
    case blush = "Blush"
    case lipstick = "Lipstick"
    case eyeshadow = "Eyeshadow"
    case mascara = "Mascara"
    case eyeliner = "Eyeliner"
    case bronzer = "Bronzer"
    case highlighter = "Highlighter"
    case primer = "Primer"
    case powder = "Powder"
    case lipgloss = "Lip Gloss"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

struct CosmeticProduct: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var shade: String
    var texture: Texture
    var productType: ProductType
    var suitableFor: String
    var notes: String
    var imageData: Data?
    var isFavorite: Bool
    var dateAdded: Date
    
    init(name: String, shade: String = "", texture: Texture = .creamy, productType: ProductType = .other, suitableFor: String = "", notes: String = "", imageData: Data? = nil, isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.shade = shade
        self.texture = texture
        self.productType = productType
        self.suitableFor = suitableFor
        self.notes = notes
        self.imageData = imageData
        self.isFavorite = isFavorite
        self.dateAdded = Date()
    }
    
    var hasImage: Bool {
        return imageData != nil
    }
    
    var hasNotes: Bool {
        return !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let type: CategoryType
    
    enum CategoryType {
        case productType(ProductType)
        case texture(Texture)
    }
}

enum TabItem: String, CaseIterable {
    case catalog = "Catalog"
    case categories = "Categories"
    case favorites = "Favorites"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var title: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .catalog:
            return "list.bullet"
        case .categories:
            return "folder"
        case .favorites:
            return "heart"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
}
