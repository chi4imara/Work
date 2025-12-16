import Foundation

enum ProductCategory: String, CaseIterable, Codable {
    case skincare = "Skincare"
    case makeup = "Makeup"
    case haircare = "Hair Care"
    
    var icon: String {
        switch self {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .haircare:
            return "scissors"
        }
    }
}

struct BeautyProduct: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: ProductCategory
    var description: String
    var rating: Int
    var comment: String
    var dateAdded: Date
    
    init(name: String, category: ProductCategory, description: String, rating: Int, comment: String = "") {
        self.name = name
        self.category = category
        self.description = description
        self.rating = rating
        self.comment = comment
        self.dateAdded = Date()
    }
}
