import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var cookingTime: Int?
    var ingredients: [String]
    var steps: [String]
    var notes: String
    var dateAdded: Date
    
    init(name: String, category: String, cookingTime: Int? = nil, ingredients: [String], steps: [String], notes: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.cookingTime = cookingTime
        self.ingredients = ingredients
        self.steps = steps
        self.notes = notes
        self.dateAdded = Date()
    }
}

enum SortOption: String, CaseIterable {
    case name = "By Name"
    case dateAdded = "By Date Added"
    case cookingTime = "By Cooking Time"
}
