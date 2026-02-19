import Foundation

struct Fragrance: Identifiable, Codable {
    let id: UUID
    var name: String
    var notes: [String]
    var season: Season
    var format: FragranceFormat
    var description: String
    let dateAdded: Date
    
    init(name: String, notes: [String], season: Season, format: FragranceFormat, description: String = "") {
        self.id = UUID()
        self.name = name
        self.notes = notes
        self.season = season
        self.format = format
        self.description = description
        self.dateAdded = Date()
    }
    
    var displayNotes: String {
        notes.prefix(2).joined(separator: ", ")
    }
}

enum Season: String, CaseIterable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var displayName: String {
        return rawValue
    }
}

enum FragranceFormat: String, CaseIterable, Codable {
    case day = "Day"
    case evening = "Evening"
    
    var displayName: String {
        return rawValue
    }
}
