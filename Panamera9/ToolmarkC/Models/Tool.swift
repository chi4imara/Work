import Foundation

struct Tool: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var type: ToolType
    var size: String
    var brand: String
    var storageLocation: String
    var description: String
    var dateCreated: Date
    
    init(name: String, type: ToolType, size: String, brand: String = "", storageLocation: String = "", description: String = "") {
        self.id = UUID()
        self.name = name
        self.type = type
        self.size = size
        self.brand = brand
        self.storageLocation = storageLocation
        self.description = description
        self.dateCreated = Date()
    }
}

enum ToolType: String, CaseIterable, Codable {
    case wrench = "Wrench"
    case screwdriver = "Screwdriver"
    case hammer = "Hammer"
    case powerTool = "Power Tool"
    case pliers = "Pliers"
    case saw = "Saw"
    case drill = "Drill"
    case measuring = "Measuring Tool"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .wrench: return "wrench.adjustable"
        case .screwdriver: return "screwdriver"
        case .hammer: return "hammer"
        case .powerTool: return "bolt"
        case .pliers: return "scissors"
        case .saw: return "wrench.and.screwdriver"
        case .drill: return "wrench.and.screwdriver.fill"
        case .measuring: return "ruler"
        case .other: return "wrench.and.screwdriver"
        }
    }
}

enum SortOption: String, CaseIterable {
    case type = "By Type"
    case brand = "By Brand"
    case size = "By Size"
    case alphabetical = "Alphabetical"
}
