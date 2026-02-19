import SwiftUI
import Foundation

struct MakeupLook: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: MakeupCategory
    var steps: [String]
    var colors: [String]
    var products: String
    var notes: String
    var isFavorite: Bool
    var dateCreated: Date
    
    init(name: String, category: MakeupCategory, steps: [String] = [], colors: [String] = [], products: String = "", notes: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.steps = steps
        self.colors = colors
        self.products = products
        self.notes = notes
        self.isFavorite = isFavorite
        self.dateCreated = Date()
    }
}

enum MakeupCategory: String, CaseIterable, Codable {
    case daily = "Daily"
    case evening = "Evening"
    case photoshoot = "Photoshoot"
    case experimental = "Experimental"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .daily:
            return "sun.max"
        case .evening:
            return "moon.stars"
        case .photoshoot:
            return "camera"
        case .experimental:
            return "paintbrush"
        }
    }
}

struct FilterOptions {
    var selectedCategories: Set<MakeupCategory> = []
    var selectedColors: Set<String> = []
    var showOnlyFavorites: Bool = false
    
    var isActive: Bool {
        return !selectedCategories.isEmpty || !selectedColors.isEmpty || showOnlyFavorites
    }
    
    mutating func reset() {
        selectedCategories.removeAll()
        selectedColors.removeAll()
        showOnlyFavorites = false
    }
}

enum SortOption: String, CaseIterable {
    case dateCreated = "Date Created"
    case name = "Name"
    case category = "Category"
    case favorites = "Favorites First"
    
    var displayName: String {
        return self.rawValue
    }
}

struct ColorPalette {
    static let availableColors = [
        "#FFB6C1",
        "#FFA07A",
        "#F0E68C",
        "#DDA0DD",
        "#98FB98",
        "#87CEEB",
        "#F5DEB3",
        "#D2691E",
        "#CD853F",
        "#BC8F8F",
        "#F4A460",
        "#DAA520",
        "#B22222",
        "#696969",
        "#2F4F4F",
        "#800080",
        "#FF69B4",
        "#FF1493",
        "#DC143C",
        "#B8860B"
    ]
    
    static func colorFromHex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: 
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        return Color(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct LookIdWrapper: Identifiable {
    let id: UUID
}
