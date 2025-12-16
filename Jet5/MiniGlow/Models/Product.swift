import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var category: ProductCategory
    var volume: String
    var comment: String
    var dateCreated: Date
    
    init(name: String, category: ProductCategory, volume: String, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.volume = volume
        self.comment = comment
        self.dateCreated = Date()
    }
}

enum ProductCategory: String, CaseIterable, Codable {
    case skincare = "Skincare"
    case makeup = "Makeup"
    case hair = "Hair"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}
