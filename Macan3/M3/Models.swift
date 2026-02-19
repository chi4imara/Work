import Foundation
import SwiftUI

enum FragranceType: String, CaseIterable, Codable {
    case daytime = "Daytime"
    case evening = "Evening"
    
    var displayName: String {
        return self.rawValue
    }
}

enum Season: String, CaseIterable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .spring: return "leaf.fill"
        case .summer: return "sun.max.fill"
        case .autumn: return "leaf"
        case .winter: return "snowflake"
        }
    }
}

struct Fragrance: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var brand: String
    var type: FragranceType
    var season: Season
    var mainNotes: String
    var atmosphere: String
    var comment: String
    var dateAdded: Date
    
    init(name: String = "", brand: String = "", type: FragranceType = .daytime, season: Season = .spring, mainNotes: String = "", atmosphere: String = "", comment: String = "") {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.type = type
        self.season = season
        self.mainNotes = mainNotes
        self.atmosphere = atmosphere
        self.comment = comment
        self.dateAdded = Date()
    }
}

struct FragranceFilter {
    var types: Set<FragranceType> = Set(FragranceType.allCases)
    var seasons: Set<Season> = Set(Season.allCases)
    var brands: Set<String> = []
    var atmospheres: Set<String> = []
    
    var isActive: Bool {
        return types.count != FragranceType.allCases.count ||
               seasons.count != Season.allCases.count ||
               !brands.isEmpty ||
               !atmospheres.isEmpty
    }
    
    mutating func reset() {
        types = Set(FragranceType.allCases)
        seasons = Set(Season.allCases)
        brands = []
        atmospheres = []
    }
}

enum SortOption: String, CaseIterable {
    case brand = "Brand"
    case type = "Type"
    case season = "Season"
    case dateAdded = "Date Added"
    
    var displayName: String {
        return self.rawValue
    }
}
