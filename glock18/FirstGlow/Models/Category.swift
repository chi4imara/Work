import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}

extension Category {
    static let defaultCategories = [
        Category(name: "Travel"),
        Category(name: "Games"),
        Category(name: "Learning"),
        Category(name: "Adventure"),
        Category(name: "Art")
    ]
}
