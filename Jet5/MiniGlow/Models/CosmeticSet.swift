import Foundation

struct CosmeticSet: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: SetCategory
    var products: [Product]
    var comment: String
    var isReady: Bool
    var dateCreated: Date
    var dateModified: Date
    var checkedProductIds: Set<UUID>
    
    init(name: String, category: SetCategory, products: [Product] = [], comment: String = "", isReady: Bool = false, checkedProductIds: Set<UUID> = []) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.products = products
        self.comment = comment
        self.isReady = isReady
        self.dateCreated = Date()
        self.dateModified = Date()
        self.checkedProductIds = checkedProductIds
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, products, comment, isReady, dateCreated, dateModified, checkedProductIds
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(SetCategory.self, forKey: .category)
        products = try container.decode([Product].self, forKey: .products)
        comment = try container.decode(String.self, forKey: .comment)
        isReady = try container.decode(Bool.self, forKey: .isReady)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        dateModified = try container.decode(Date.self, forKey: .dateModified)
        checkedProductIds = try container.decodeIfPresent(Set<UUID>.self, forKey: .checkedProductIds) ?? []
    }
}

enum SetCategory: String, CaseIterable, Codable {
    case office = "Office"
    case bag = "Bag"
    case travel = "Travel"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}
