import Foundation

struct SkinEntry: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var condition: SkinCondition
    var notes: String
    
    enum SkinCondition: String, CaseIterable, Codable {
        case dry = "Dry"
        case oily = "Oily"
        case irritated = "Irritated"
        case normal = "Normal"
        case improved = "Improved"
        
        var icon: String {
            switch self {
            case .dry:
                return "drop.circle"
            case .oily:
                return "circle.fill"
            case .irritated:
                return "exclamationmark.circle"
            case .normal:
                return "checkmark.circle"
            case .improved:
                return "star.circle"
            }
        }
        
        var description: String {
            switch self {
            case .dry:
                return "Skin feels dry and tight"
            case .oily:
                return "Skin appears oily or greasy"
            case .irritated:
                return "Skin is red or irritated"
            case .normal:
                return "Skin feels balanced and healthy"
            case .improved:
                return "Noticeable improvement in skin condition"
            }
        }
    }
    
    init(condition: SkinCondition, notes: String = "", date: Date = Date()) {
        self.condition = condition
        self.notes = notes
        self.date = date
    }
}