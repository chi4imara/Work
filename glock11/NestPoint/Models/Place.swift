import Foundation

struct Place: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: String
    var address: String
    var note: String
    var isFavorite: Bool
    var dateAdded: Date
    
    init(name: String, category: String, address: String = "", note: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.address = address
        self.note = note
        self.isFavorite = isFavorite
        self.dateAdded = Date()
    }
}
