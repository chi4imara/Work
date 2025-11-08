import Foundation

struct FirstExperience: Identifiable, Codable {
    var id: UUID
    var title: String
    var category: String?
    var date: Date
    var place: String?
    var note: String?
    var createdAt: Date
    
    init(title: String, category: String? = nil, date: Date, place: String? = nil, note: String? = nil) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.date = date
        self.place = place
        self.note = note
        self.createdAt = Date()
    }
}

