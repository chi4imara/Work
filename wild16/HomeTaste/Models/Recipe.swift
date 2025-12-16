import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    var title: String
    var ingredients: String
    var instructions: String
    var category: String?
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, ingredients: String = "", instructions: String = "", category: String? = nil) {
        self.id = UUID()
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
        self.category = category
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    var shortDescription: String {
        let words = ingredients.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        let firstWords = Array(words.prefix(4))
        return firstWords.joined(separator: ", ")
    }
    
    mutating func updateContent(title: String, ingredients: String, instructions: String, category: String? = nil) {
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
        self.category = category
        self.dateModified = Date()
    }
}
