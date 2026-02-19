import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var text: String
    var category: String
    var isFavorite: Bool
    let createdAt: Date
    
    init(text: String, category: String, isFavorite: Bool = false) {
        self.id = UUID()
        self.text = text
        self.category = category
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }
    
    var firstLine: String {
        let lines = text.components(separatedBy: .newlines)
        return lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: createdAt)
    }
}

struct Category: Identifiable, Codable {
    let id: UUID
    let name: String
    var notesCount: Int = 0
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

extension Category {
    static let defaultCategories = [
        Category(name: "Quotes"),
        Category(name: "Ideas"),
        Category(name: "Notes")
    ]
}
