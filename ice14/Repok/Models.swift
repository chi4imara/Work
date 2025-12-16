import Foundation

struct Gift: Identifiable, Codable {
    let id: UUID
    var title: String
    var person: String
    var categoryId: UUID
    var note: String
    var status: GiftStatus
    let createdAt: Date
    var updatedAt: Date
    
    enum GiftStatus: String, CaseIterable, Codable {
        case planned = "planned"
        case bought = "bought"
        
        var displayName: String {
            switch self {
            case .planned:
                return "In Plans"
            case .bought:
                return "Bought"
            }
        }
    }
    
    init(title: String, person: String = "", categoryId: UUID, note: String = "", status: GiftStatus = .planned) {
        self.id = UUID()
        self.title = title
        self.person = person
        self.categoryId = categoryId
        self.note = note
        self.status = status
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    var iconName: String
    let createdAt: Date
    var updatedAt: Date
    
    init(name: String, iconName: String) {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    static let defaultCategories = [
        Category(name: "Electronics", iconName: "headphones"),
        Category(name: "Clothing", iconName: "tshirt"),
        Category(name: "Books", iconName: "book"),
        Category(name: "Hobby", iconName: "paintbrush")
    ]
}

struct Event: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date
    let createdAt: Date
    var updatedAt: Date
    
    init(title: String, date: Date) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct GiftEventRelation: Identifiable, Codable {
    let id: UUID
    let giftId: UUID
    let eventId: UUID
    let createdAt: Date
    
    init(giftId: UUID, eventId: UUID) {
        self.id = UUID()
        self.giftId = giftId
        self.eventId = eventId
        self.createdAt = Date()
    }
}
