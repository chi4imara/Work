import Foundation

struct InteriorIdea: Identifiable, Codable {
    let id = UUID()
    var title: String
    var category: Category
    var note: String
    var isFavorite: Bool
    var dateAdded: Date
    var dateModified: Date
    
    enum Category: String, CaseIterable, Codable {
        case livingRoom = "Living Room"
        case kitchen = "Kitchen"
        case bedroom = "Bedroom"
        case bathroom = "Bathroom"
        case hallway = "Hallway"
        case other = "Other"
    }
    
    init(title: String, category: Category, note: String, isFavorite: Bool = false) {
        self.title = title
        self.category = category
        self.note = note
        self.isFavorite = isFavorite
        self.dateAdded = Date()
        self.dateModified = Date()
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
    
    var notePreview: String {
        let lines = note.components(separatedBy: .newlines)
        let firstTwoLines = Array(lines.prefix(2))
        return firstTwoLines.joined(separator: "\n")
    }
}
