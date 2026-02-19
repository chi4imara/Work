import Foundation

struct Brand: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: BrandCategory
    var rating: Int
    var description: String
    var dateAdded: Date
    
    init(name: String, category: BrandCategory, rating: Int, description: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.rating = rating
        self.description = description
        self.dateAdded = Date()
    }
}

enum BrandCategory: String, CaseIterable, Codable {
    case clothing = "Clothing"
    case cosmetics = "Cosmetics"
    case accessories = "Accessories"
    case perfume = "Perfume"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

extension Brand {
    static let sampleBrands: [Brand] = [
        Brand(name: "Dior", category: .cosmetics, rating: 5, description: "Favorite fragrances"),
        Brand(name: "Chanel", category: .clothing, rating: 4, description: "Elegant designs"),
        Brand(name: "Gucci", category: .accessories, rating: 5, description: "Luxury accessories")
    ]
}
