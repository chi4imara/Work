import Foundation

enum ProcedureType: String, CaseIterable, Codable {
    case trim = "Trim"
    case correction = "Correction"
    case oil = "Oil"
    case balm = "Balm"
    case styling = "Styling"
    case combing = "Combing"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .trim:
            return "scissors"
        case .correction:
            return "pencil"
        case .oil:
            return "drop"
        case .balm:
            return "leaf"
        case .styling:
            return "wand.and.rays"
        case .combing:
            return "comb"
        case .other:
            return "ellipsis"
        }
    }
}
