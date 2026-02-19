import Foundation

enum DeviceCategory: String, CaseIterable, Identifiable, Codable {
    case phones = "Phones"
    case computers = "Computers"
    case electronics = "Electronics"
    case tools = "Tools"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return self.rawValue
    }
}

enum DeviceCondition: String, CaseIterable, Identifiable, Codable {
    case new = "New"
    case good = "Good"
    case used = "Used"
    case needsRepair = "Needs Repair"
    
    var id: String { self.rawValue }
}

struct Device: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: DeviceCategory
    var purchaseDate: Date
    var specifications: String
    var condition: DeviceCondition
    var comment: String
    
    init(id: UUID = UUID(), name: String, category: DeviceCategory, purchaseDate: Date, specifications: String, condition: DeviceCondition, comment: String) {
        self.id = id
        self.name = name
        self.category = category
        self.purchaseDate = purchaseDate
        self.specifications = specifications
        self.condition = condition
        self.comment = comment
    }
    
    var firstSpecificationLine: String {
        return specifications.components(separatedBy: .newlines).first ?? ""
    }
}

enum FilterCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case phones = "Phones"
    case computers = "Computers"
    case electronics = "Electronics"
    case tools = "Tools"
    
    var id: String { self.rawValue }
    
    var deviceCategory: DeviceCategory? {
        switch self {
        case .all:
            return nil
        case .phones:
            return .phones
        case .computers:
            return .computers
        case .electronics:
            return .electronics
        case .tools:
            return .tools
        }
    }
}
