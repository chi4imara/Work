import Foundation

struct Woman: Identifiable, Codable {
    let id: UUID
    var name: String
    var profession: String
    var quote: String
    var personalNote: String
    var isFavorite: Bool
    var dateCreated: Date
    
    init(name: String, profession: String, quote: String = "", personalNote: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.profession = profession
        self.quote = quote
        self.personalNote = personalNote
        self.isFavorite = isFavorite
        self.dateCreated = Date()
    }
}

extension Woman {
    var hasQuote: Bool {
        !quote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasNote: Bool {
        !personalNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var quotePreview: String {
        let maxLength = 50
        if quote.count > maxLength {
            return String(quote.prefix(maxLength)) + "..."
        }
        return quote
    }
}

struct WomanID: Identifiable {
    let id: UUID
}
