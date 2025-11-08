import Foundation

struct Category: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    
    static let defaultCategories = [
        Category(name: "Room"),
        Category(name: "Surfaces"),
        Category(name: "Bathroom"),
        Category(name: "Floors"),
        Category(name: "Kitchen"),
        Category(name: "Dust"),
        Category(name: "Windows")
    ]
}

extension Category {
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
