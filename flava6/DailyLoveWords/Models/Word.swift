import Foundation

struct Word: Identifiable, Codable, Equatable {
    let id: UUID
    let word: String
    let translation: String?
    let comment: String?
    let dateAdded: Date
    
    init(word: String, translation: String? = nil, comment: String? = nil, dateAdded: Date = Date()) {
        self.id = UUID()
        self.word = word
        self.translation = translation
        self.comment = comment
        self.dateAdded = dateAdded
    }
    
    init(id: UUID, word: String, translation: String? = nil, comment: String? = nil, dateAdded: Date = Date()) {
        self.id = id
        self.word = word
        self.translation = translation
        self.comment = comment
        self.dateAdded = dateAdded
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: dateAdded)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(dateAdded)
    }
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.id == rhs.id &&
               lhs.word == rhs.word &&
               lhs.translation == rhs.translation &&
               lhs.comment == rhs.comment &&
               lhs.dateAdded == rhs.dateAdded
    }
}
