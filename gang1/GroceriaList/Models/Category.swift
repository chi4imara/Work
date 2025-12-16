import Foundation

struct Category: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var icon: String
    
    init(name: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
    }
    
    static let defaultCategories = [
        Category(name: "Products", icon: "cart.fill"),
        Category(name: "Drinks", icon: "cup.and.saucer.fill"),
        Category(name: "Household", icon: "house.fill"),
        Category(name: "Other", icon: "ellipsis.circle.fill")
    ]
}
