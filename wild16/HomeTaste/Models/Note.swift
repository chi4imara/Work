import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var content: String
    var dateCreated: Date
    var recipeId: UUID?
    var recipeName: String?
    
    init(content: String, recipeId: UUID? = nil, recipeName: String? = nil) {
        self.id = UUID()
        self.content = content
        self.dateCreated = Date()
        self.recipeId = recipeId
        self.recipeName = recipeName
    }
    
    var previewText: String {
        let lines = content.components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let previewLines = Array(lines.prefix(3))
        return previewLines.joined(separator: "\n")
    }
    
    var isLinkedToRecipe: Bool {
        return recipeId != nil
    }
}
