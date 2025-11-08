import Foundation

struct Category: Identifiable, Codable, Equatable {
    let id = UUID()
    var name: String
    var isDefault: Bool
    
    init(name: String, isDefault: Bool = false) {
        self.name = name
        self.isDefault = isDefault
    }
}

extension Category {
    static let defaultCategories = [
        Category(name: "Quiet Leisure", isDefault: true),
        Category(name: "Games", isDefault: true),
        Category(name: "Creativity", isDefault: true),
        Category(name: "Cooking", isDefault: true),
        Category(name: "Sports", isDefault: true)
    ]
}
