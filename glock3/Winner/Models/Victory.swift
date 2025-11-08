import Foundation

struct Victory: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var category: String?
    var date: Date
    var note: String?
    
    init(title: String, category: String? = nil, date: Date = Date(), note: String? = nil) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.date = date
        self.note = note
    }
    
    init(id: UUID, title: String, category: String? = nil, date: Date = Date(), note: String? = nil) {
        self.id = id
        self.title = title
        self.category = category
        self.date = date
        self.note = note
    }
}

extension Victory {
    static let sampleData: [Victory] = [
    ]
}
