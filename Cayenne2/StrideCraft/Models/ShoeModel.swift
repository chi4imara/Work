import Foundation

struct Shoe: Identifiable, Codable {
    let id: UUID
    var model: String
    var category: ShoeCategory
    var condition: ShoeCondition
    var season: ShoeSeason
    var purchaseDate: Date
    var comment: String
    
    init(model: String, category: ShoeCategory, condition: ShoeCondition, season: ShoeSeason, purchaseDate: Date, comment: String = "") {
        self.id = UUID()
        self.model = model
        self.category = category
        self.condition = condition
        self.season = season
        self.purchaseDate = purchaseDate
        self.comment = comment
    }
}

enum ShoeCategory: String, CaseIterable, Codable {
    case sneakers = "Sneakers"
    case boots = "Boots"
    case dress = "Dress Shoes"
    case summer = "Summer Shoes"
    case winter = "Winter Shoes"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

enum ShoeCondition: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case average = "Average"
    case poor = "Poor"
    
    var displayName: String {
        return self.rawValue
    }
}

enum ShoeSeason: String, CaseIterable, Codable {
    case winter = "Winter"
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case allSeason = "All Season"
    
    var displayName: String {
        return self.rawValue
    }
}
