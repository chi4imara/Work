import Foundation

struct Breakfast: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var category: BreakfastCategory
    var dishes: String
    var drink: String
    var atmosphereDescription: String
    var dateCreated: Date
    
    init(name: String, category: BreakfastCategory, dishes: String, drink: String, atmosphereDescription: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.dishes = dishes
        self.drink = drink
        self.atmosphereDescription = atmosphereDescription
        self.dateCreated = Date()
    }
}

enum BreakfastCategory: String, CaseIterable, Codable {
    case weekday = "Weekday"
    case weekend = "Weekend"
    case holiday = "Holiday"
    case outdoor = "Outdoor"
    
    var displayName: String {
        switch self {
        case .weekday:
            return "Weekday"
        case .weekend:
            return "Weekend"
        case .holiday:
            return "Holiday"
        case .outdoor:
            return "Outdoor"
        }
    }
}
