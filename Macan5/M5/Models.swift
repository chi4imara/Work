import Foundation

enum ProductStatus: String, CaseIterable, Codable {
    case inUse = "In Use"
    case inStock = "In Stock"
    case needToBuy = "Need to Buy"
    
    var displayName: String {
        return self.rawValue
    }
}

enum ProductCategory: String, CaseIterable, Codable {
    case skincare = "Skincare"
    case makeup = "Makeup"
    case haircare = "Haircare"
    case bodycare = "Bodycare"
    case fragrance = "Fragrance"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Product: Identifiable, Codable {
    let id: UUID
    var name: String
    var brand: String
    var category: ProductCategory
    var quantity: Int
    var status: ProductStatus
    var comment: String
    var dateAdded: Date
    var dateModified: Date
    
    init(name: String, brand: String, category: ProductCategory, quantity: Int = 1, status: ProductStatus = .inStock, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.category = category
        self.quantity = quantity
        self.status = status
        self.comment = comment
        self.dateAdded = Date()
        self.dateModified = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case brand
        case category
        case quantity
        case status
        case comment
        case dateAdded
        case dateModified
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.brand = try container.decode(String.self, forKey: .brand)
        let categoryString = try container.decode(String.self, forKey: .category)
        self.category = ProductCategory(rawValue: categoryString) ?? .other
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        let statusString = try container.decode(String.self, forKey: .status)
        self.status = ProductStatus(rawValue: statusString) ?? .inStock
        self.comment = try container.decode(String.self, forKey: .comment)
        self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
        self.dateModified = try container.decode(Date.self, forKey: .dateModified)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(brand, forKey: .brand)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(comment, forKey: .comment)
        try container.encode(dateAdded, forKey: .dateAdded)
        try container.encode(dateModified, forKey: .dateModified)
    }
    
    mutating func updateStatus(_ newStatus: ProductStatus) {
        self.status = newStatus
        self.dateModified = Date()
    }
    
    mutating func updateQuantity(_ newQuantity: Int) {
        self.quantity = newQuantity
        self.dateModified = Date()
    }
}

struct FilterOptions {
    var selectedStatuses: Set<ProductStatus> = []
    var selectedCategories: Set<ProductCategory> = []
    var brandFilter: String = ""
    
    var isActive: Bool {
        return !selectedStatuses.isEmpty || !selectedCategories.isEmpty || !brandFilter.isEmpty
    }
    
    mutating func reset() {
        selectedStatuses.removeAll()
        selectedCategories.removeAll()
        brandFilter = ""
    }
}

struct CategorySummary {
    let category: ProductCategory
    let count: Int
    let products: [Product]
}
