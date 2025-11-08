import Foundation

enum EventType: String, CaseIterable, Codable {
    case birthday = "birthday"
    case newYear = "new_year"
    case anniversary = "anniversary"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .birthday:
            return "Birthday"
        case .newYear:
            return "New Year"
        case .anniversary:
            return "Anniversary"
        case .other:
            return "Other"
        }
    }
}
