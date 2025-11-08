import Foundation

enum PlaceCategory: String, CaseIterable, Codable {
    case school = "School"
    case yard = "Yard"
    case trip = "Trip"
    case other = "Other"
    
    var displayName: String {
        switch self {
        case .school:
            return "School"
        case .yard:
            return "Yard"
        case .trip:
            return "Trip"
        case .other:
            return "Other"
        }
    }
}

struct Place: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: PlaceCategory
    var description: String
    var dateAdded: Date
    
    init(id: UUID = UUID(), name: String, category: PlaceCategory, description: String = "", dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.dateAdded = dateAdded
    }
}

extension Place {
    static let sampleData: [Place] = [
    ]
}
