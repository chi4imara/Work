import Foundation

enum GiftStatus: String, CaseIterable, Codable {
    case idea = "idea"
    case purchased = "purchased"
    case gifted = "gifted"
    
    var displayName: String {
        switch self {
        case .idea:
            return "Idea"
        case .purchased:
            return "Purchased"
        case .gifted:
            return "Gifted"
        }
    }
    
    var icon: String {
        switch self {
        case .idea:
            return "lightbulb"
        case .purchased:
            return "cart"
        case .gifted:
            return "gift"
        }
    }
}
