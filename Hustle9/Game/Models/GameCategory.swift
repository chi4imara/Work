import Foundation

enum GameCategory: String, CaseIterable, Identifiable, Codable {
    case card = "Card Games"
    case strategy = "Strategy"
    case party = "Party Games"
    case family = "Family"
    case other = "Other"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .card:
            return "suit.club.fill"
        case .strategy:
            return "brain.head.profile"
        case .party:
            return "party.popper.fill"
        case .family:
            return "house.fill"
        case .other:
            return "gamecontroller.fill"
        }
    }
    
    var displayName: String {
        return rawValue
    }
}
