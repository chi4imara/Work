import Foundation

struct Bag: Identifiable, Codable {
    var id: UUID
    let name: String
    let brand: String
    let category: BagCategory
    let size: BagSize
    let price: Double
    let imageURL: String
    let color: String
    let style: BagStyle
    var isFavorite: Bool
    let description: String
    
    init(id: UUID = UUID(), name: String, brand: String, category: BagCategory, size: BagSize, price: Double, imageURL: String, color: String, style: BagStyle, isFavorite: Bool = false, description: String) {
        self.id = id
        self.name = name
        self.brand = brand
        self.category = category
        self.size = size
        self.price = price
        self.imageURL = imageURL
        self.color = color
        self.style = style
        self.isFavorite = isFavorite
        self.description = description
    }
}

enum BagCategory: String, CaseIterable, Codable {
    case tote = "Tote"
    case clutch = "Clutch"
    case crossbody = "Crossbody"
    case backpack = "Backpack"
    case shoulderBag = "Shoulder Bag"
    case shopper = "Shopper"
    
    var icon: String {
        switch self {
        case .tote: return "bag.fill"
        case .clutch: return "rectangle.fill"
        case .crossbody: return "bag.badge.plus"
        case .backpack: return "backpack.fill"
        case .shoulderBag: return "handbag.fill"
        case .shopper: return "bag.fill.badge.plus"
        }
    }
}

enum BagSize: String, CaseIterable, Codable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case extraLarge = "Extra Large"
}

enum BagStyle: String, CaseIterable, Codable {
    case classic = "Classic"
    case casual = "Casual"
    case evening = "Evening"
    case sporty = "Sporty"
    case trendy = "Trendy"
    case business = "Business"
    case bohemian = "Bohemian"
}

struct BagFilter {
    var categories: Set<BagCategory> = []
    var sizes: Set<BagSize> = []
    var styles: Set<BagStyle> = []
    var brands: Set<String> = []
    var colors: Set<String> = []
    var priceRange: ClosedRange<Double> = 0...1000
    
    var isActive: Bool {
        return !categories.isEmpty || !sizes.isEmpty || !styles.isEmpty || 
               !brands.isEmpty || !colors.isEmpty || priceRange != 0...1000
    }
    
    mutating func reset() {
        categories.removeAll()
        sizes.removeAll()
        styles.removeAll()
        brands.removeAll()
        colors.removeAll()
        priceRange = 0...1000
    }
}
