import Foundation

enum ServiceType: String, CaseIterable, Codable {
    case haircut = "Haircut"
    case shave = "Shave"
    case trimmer = "Trimmer"
    case beardModeling = "Beard Modeling"
    case mustacheCorrection = "Mustache Correction"
    case styling = "Styling"
    case other = "Other"
    
    var category: ServiceCategory {
        switch self {
        case .haircut:
            return .haircuts
        case .shave:
            return .shaving
        case .trimmer, .beardModeling, .mustacheCorrection, .styling, .other:
            return .care
        }
    }
}

enum ServiceCategory: String, CaseIterable, Codable {
    case all = "All"
    case haircuts = "Haircuts"
    case shaving = "Shaving"
    case care = "Care"
}

struct Service: Codable, Identifiable, Hashable {
    let id: UUID
    let type: ServiceType
    let customName: String?
    
    var displayName: String {
        return customName ?? type.rawValue
    }
    
    init(type: ServiceType, customName: String? = nil) {
        self.id = UUID()
        self.type = type
        self.customName = customName
    }
}
