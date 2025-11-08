import Foundation

enum GiftStatus: String, CaseIterable, Codable {
    case idea = "idea"
    case bought = "bought"
    case gifted = "gifted"
    
    var displayName: String {
        switch self {
        case .idea:
            return "Idea"
        case .bought:
            return "Bought"
        case .gifted:
            return "Gifted"
        }
    }
    
    var iconName: String {
        switch self {
        case .idea:
            return "lightbulb"
        case .bought:
            return "cart.fill"
        case .gifted:
            return "gift.fill"
        }
    }
}

enum GiftOccasion: String, CaseIterable, Codable {
    case birthday = "birthday"
    case wedding = "wedding"
    case newYear = "newYear"
    case anniversary = "anniversary"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .birthday:
            return "Birthday"
        case .wedding:
            return "Wedding"
        case .newYear:
            return "New Year"
        case .anniversary:
            return "Anniversary"
        case .other:
            return "Other"
        }
    }
}

struct GiftIdea: Identifiable, Codable, Equatable {
    let id: UUID
    var recipientName: String
    var giftDescription: String
    var occasion: GiftOccasion?
    var status: GiftStatus
    var estimatedPrice: Double?
    var comment: String
    var dateAdded: Date
    var dateModified: Date
    
    init(recipientName: String, 
         giftDescription: String, 
         occasion: GiftOccasion? = nil, 
         status: GiftStatus = .idea, 
         estimatedPrice: Double? = nil, 
         comment: String = "") {
        self.id = UUID()
        self.recipientName = recipientName
        self.giftDescription = giftDescription
        self.occasion = occasion
        self.status = status
        self.estimatedPrice = estimatedPrice
        self.comment = comment
        self.dateAdded = Date()
        self.dateModified = Date()
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
}
