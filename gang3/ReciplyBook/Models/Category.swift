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
        Category(name: "Breakfast"),
        Category(name: "Lunch"),
        Category(name: "Dinner"),
        Category(name: "Dessert"),
        Category(name: "Drink")
    ]
}
