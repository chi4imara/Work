import Foundation

struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

extension Category {
    static let defaultCategories = [
        Category(name: "Clothing"),
        Category(name: "Dishes"),
        Category(name: "Jewelry"),
        Category(name: "Watches"),
        Category(name: "Books"),
        Category(name: "Furniture"),
        Category(name: "Toys"),
        Category(name: "Documents")
    ]
}
