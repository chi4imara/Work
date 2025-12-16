import Foundation

struct WordModel: Identifiable, Codable {
    let id: UUID
    var word: String
    var definition: String
    var note: String?
    var dateAdded: Date
    var categoryName: String
    
    init(id: UUID = UUID(), word: String, definition: String, note: String? = nil, dateAdded: Date = Date(), categoryName: String) {
        self.id = id
        self.word = word
        self.definition = definition
        self.note = note
        self.dateAdded = dateAdded
        self.categoryName = categoryName
    }
}
