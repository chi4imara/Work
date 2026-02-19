import Foundation
import SwiftUI

struct Accessory: Identifiable, Codable, Equatable {
    var id: UUID
    let name: String
    let brand: String
    let category: AccessoryCategory
    let price: Double
    let imageURL: String
    let colors: [String]
    let style: AccessoryStyle
    let description: String
    var isFavorite: Bool
    
    init(id: UUID = UUID(), name: String, brand: String, category: AccessoryCategory, price: Double, imageURL: String = "", colors: [String] = [], style: AccessoryStyle, description: String = "", isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.brand = brand
        self.category = category
        self.price = price
        self.imageURL = imageURL
        self.colors = colors
        self.style = style
        self.description = description
        self.isFavorite = isFavorite
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, brand, category, price, imageURL, colors, style, description, isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try c.decode(String.self, forKey: .name)
        brand = try c.decode(String.self, forKey: .brand)
        category = try c.decode(AccessoryCategory.self, forKey: .category)
        price = try c.decode(Double.self, forKey: .price)
        imageURL = try c.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        colors = try c.decodeIfPresent([String].self, forKey: .colors) ?? []
        style = try c.decode(AccessoryStyle.self, forKey: .style)
        description = try c.decodeIfPresent(String.self, forKey: .description) ?? ""
        isFavorite = try c.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(brand, forKey: .brand)
        try c.encode(category, forKey: .category)
        try c.encode(price, forKey: .price)
        try c.encode(imageURL, forKey: .imageURL)
        try c.encode(colors, forKey: .colors)
        try c.encode(style, forKey: .style)
        try c.encode(description, forKey: .description)
        try c.encode(isFavorite, forKey: .isFavorite)
    }
}

enum AccessoryCategory: String, CaseIterable, Codable {
    case bag = "Bag"
    case jewelry = "Jewelry"
    case belt = "Belt"
    case hat = "Hat"
    
    var icon: String {
        switch self {
        case .bag: return "handbag"
        case .jewelry: return "sparkles"
        case .belt: return "rectangle"
        case .hat: return "hat.cap"
        }
    }
}

enum AccessoryStyle: String, CaseIterable, Codable {
    case classic = "Classic"
    case casual = "Casual"
    case evening = "Evening"
    case sport = "Sport"
    
    var color: Color {
        switch self {
        case .classic: return AppColors.textBlue
        case .casual: return AppColors.accentGreen
        case .evening: return AppColors.accentPink
        case .sport: return AppColors.primaryYellow
        }
    }
}

struct UserProfile: Codable {
    var name: String
    var email: String
    var avatarURL: String?
    var favoriteStyles: [AccessoryStyle]
    var favoriteBrands: [String]
    var budget: Double
    var notifications: NotificationSettings
    
    static let defaultProfile = UserProfile(
        name: "User",
        email: "user@example.com",
        favoriteStyles: [.casual, .classic],
        favoriteBrands: ["Chanel", "Gucci", "Prada"],
        budget: 1000.0,
        notifications: NotificationSettings()
    )
}

struct NotificationSettings: Codable {
    var newCollections: Bool = true
    var stylistTips: Bool = true
    var sales: Bool = true
}

struct Collection: Identifiable, Codable {
    let id: UUID
    var name: String
    var accessories: [Accessory]
    var createdDate: Date
    
    init(id: UUID = UUID(), name: String, accessories: [Accessory], createdDate: Date) {
        self.id = id
        self.name = name
        self.accessories = accessories
        self.createdDate = createdDate
    }
    
    enum CodingKeys: String, CodingKey { case id, name, accessories, createdDate }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try c.decode(String.self, forKey: .name)
        accessories = try c.decode([Accessory].self, forKey: .accessories)
        createdDate = try c.decode(Date.self, forKey: .createdDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(accessories, forKey: .accessories)
        try c.encode(createdDate, forKey: .createdDate)
    }
}

struct TryOnSession: Identifiable, Codable {
    let id: UUID
    let accessoryId: UUID
    let styleRawValue: String
    let colors: [String]
    let date: Date
    let rating: Int
    let notes: String?
    
    init(id: UUID = UUID(), accessoryId: UUID, styleRawValue: String, colors: [String] = [], date: Date, rating: Int, notes: String? = nil) {
        self.id = id
        self.accessoryId = accessoryId
        self.styleRawValue = styleRawValue
        self.colors = colors
        self.date = date
        self.rating = rating
        self.notes = notes
    }
    
    var style: AccessoryStyle {
        AccessoryStyle(rawValue: styleRawValue) ?? .casual
    }
    
    enum CodingKeys: String, CodingKey { case id, accessoryId, styleRawValue, colors, date, rating, notes }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        accessoryId = try c.decode(UUID.self, forKey: .accessoryId)
        styleRawValue = try c.decodeIfPresent(String.self, forKey: .styleRawValue) ?? AccessoryStyle.casual.rawValue
        colors = try c.decodeIfPresent([String].self, forKey: .colors) ?? []
        date = try c.decode(Date.self, forKey: .date)
        rating = try c.decode(Int.self, forKey: .rating)
        notes = try c.decodeIfPresent(String.self, forKey: .notes)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(accessoryId, forKey: .accessoryId)
        try c.encode(styleRawValue, forKey: .styleRawValue)
        try c.encode(colors, forKey: .colors)
        try c.encode(date, forKey: .date)
        try c.encode(rating, forKey: .rating)
        try c.encode(notes, forKey: .notes)
    }
}

struct Achievement: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    var isUnlocked: Bool
    var progress: Double
    
    init(id: UUID = UUID(), title: String, description: String, icon: String, isUnlocked: Bool, progress: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.isUnlocked = isUnlocked
        self.progress = progress
    }
    
    static let defaultAchievements: [Achievement] = [
        Achievement(title: "First Try-On", description: "Complete your first virtual try-on", icon: "star.fill", isUnlocked: false, progress: 0),
        Achievement(title: "Style Explorer", description: "Try on 5 different styles", icon: "eye.fill", isUnlocked: false, progress: 0),
        Achievement(title: "Collection Master", description: "Create 3 collections", icon: "folder.fill", isUnlocked: false, progress: 0)
    ]
}
