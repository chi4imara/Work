import Foundation

struct CategoryModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var colorIndex: Int
    var wordsCount: Int
    var lastWordAdded: String?
    
    init(id: UUID = UUID(), name: String, colorIndex: Int = 0, wordsCount: Int = 0, lastWordAdded: String? = nil) {
        self.id = id
        self.name = name
        self.colorIndex = colorIndex
        self.wordsCount = wordsCount
        self.lastWordAdded = lastWordAdded
    }
}

extension CategoryModel {
    static let defaultCategories = [
        CategoryModel(name: "Nature", colorIndex: 0),
        CategoryModel(name: "Art", colorIndex: 1),
        CategoryModel(name: "Emotions", colorIndex: 2),
        CategoryModel(name: "Other", colorIndex: 3)
    ]
}
