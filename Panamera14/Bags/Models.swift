import Foundation
import SwiftUI

struct Bag: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var imageData: Data?
    var size: BagSize
    var style: BagStyle
    var suitableFor: String
    var notes: String
    var isFavorite: Bool
    var dateCreated: Date
    
    init(name: String, imageData: Data? = nil, size: BagSize, style: BagStyle, suitableFor: String, notes: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.imageData = imageData
        self.size = size
        self.style = style
        self.suitableFor = suitableFor
        self.notes = notes
        self.isFavorite = isFavorite
        self.dateCreated = Date()
    }
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
}

enum BagSize: String, CaseIterable, Codable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case extraLarge = "Extra Large"
    
    var displayName: String {
        return self.rawValue
    }
}

enum BagStyle: String, CaseIterable, Codable {
    case classic = "Classic"
    case casual = "Casual"
    case evening = "Evening"
    case sport = "Sport"
    case business = "Business"
    case vintage = "Vintage"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let type: CategoryType
}

enum CategoryType {
    case size(BagSize)
    case style(BagStyle)
}

enum TabItem: String, CaseIterable {
    case bags = "Bags"
    case categories = "Categories"
    case favorites = "Favorites"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .bags:
            return "bag"
        case .categories:
            return "square.grid.2x2"
        case .favorites:
            return "heart"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
}
