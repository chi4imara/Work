import Foundation

enum Season: String, CaseIterable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Fragrance: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var notes: String
    var season: Season?
    var occasions: String
    var personalNotes: String
    var isFavorite: Bool
    var dateCreated: Date
    
    init(name: String, notes: String = "", season: Season? = nil, occasions: String = "", personalNotes: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.notes = notes
        self.season = season
        self.occasions = occasions
        self.personalNotes = personalNotes
        self.isFavorite = isFavorite
        self.dateCreated = Date()
    }
    
    var keyNotes: String {
        let notesList = notes.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        return notesList.prefix(2).joined(separator: ", ")
    }
    
    var hasNotes: Bool {
        return !notes.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var hasOccasions: Bool {
        return !occasions.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var hasPersonalNotes: Bool {
        return !personalNotes.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

struct Category {
    let name: String
    let count: Int
    let type: CategoryType
}

enum CategoryType {
    case season(Season)
    case occasion(String)
}

enum FragranceFilter {
    case all
    case favorites
    case season(Season)
    case occasion(String)
    case search(String)
}

extension Fragrance {
    static let sampleData: [Fragrance] = [
        Fragrance(
            name: "Chanel No. 5",
            notes: "ylang-ylang, rose, sandalwood",
            season: .spring,
            occasions: "evening, special events",
            personalNotes: "Classic and elegant, perfect for important occasions"
        ),
        Fragrance(
            name: "Tom Ford Black Orchid",
            notes: "black orchid, chocolate, vanilla",
            season: .winter,
            occasions: "night out, date",
            personalNotes: "Bold and mysterious, makes a statement",
            isFavorite: true
        ),
        Fragrance(
            name: "Dolce & Gabbana Light Blue",
            notes: "lemon, apple, bamboo",
            season: .summer,
            occasions: "daily wear, office",
            personalNotes: "Fresh and light, perfect for hot weather"
        )
    ]
}
