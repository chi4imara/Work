import Foundation

struct Category: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var gameCount: Int = 0
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

extension Category {
    static let defaultCategories = [
        Category(name: "Active"),
        Category(name: "Word"),
        Category(name: "Board"),
        Category(name: "Party"),
        Category(name: "Creative")
    ]
}
