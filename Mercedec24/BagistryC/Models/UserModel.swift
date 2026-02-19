import Foundation

struct User: Codable {
    var id: UUID
    var name: String
    var email: String
    var avatar: String?
    var preferredSizes: Set<BagSize>
    var favoriteBrands: Set<String>
    var preferredStyles: Set<BagStyle>
    var styleGoals: Set<StyleGoal>
    var notificationSettings: NotificationSettings
    
    init(id: UUID = UUID(), name: String = "User", email: String = "user@example.com", avatar: String? = nil, preferredSizes: Set<BagSize> = [.medium], favoriteBrands: Set<String> = [], preferredStyles: Set<BagStyle> = [.casual], styleGoals: Set<StyleGoal> = [.everyday], notificationSettings: NotificationSettings = NotificationSettings()) {
        self.id = id
        self.name = name
        self.email = email
        self.avatar = avatar
        self.preferredSizes = preferredSizes
        self.favoriteBrands = favoriteBrands
        self.preferredStyles = preferredStyles
        self.styleGoals = styleGoals
        self.notificationSettings = notificationSettings
    }
}

enum StyleGoal: String, CaseIterable, Codable {
    case everyday = "Everyday Style"
    case evening = "Evening Events"
    case travel = "Travel"
    case business = "Business"
    case casual = "Casual Outings"
    case special = "Special Occasions"
}

struct NotificationSettings: Codable {
    var newModels: Bool = true
    var discounts: Bool = true
    var stylistRecommendations: Bool = true
    var collectionUpdates: Bool = false
}

struct TryOnSession: Identifiable, Codable {
    var id: UUID
    let bagId: UUID
    let date: Date
    let style: BagStyle
    let brand: String
    let category: BagCategory
    var rating: Int?
    var notes: String?
    
    init(id: UUID = UUID(), bag: Bag, rating: Int? = nil, notes: String? = nil) {
        self.id = id
        self.bagId = bag.id
        self.date = Date()
        self.style = bag.style
        self.brand = bag.brand
        self.category = bag.category
        self.rating = rating
        self.notes = notes
    }
}

struct Achievement: Identifiable, Codable {
    var id: UUID
    let title: String
    let description: String
    let icon: String
    var isUnlocked: Bool
    var unlockedDate: Date?
    
    init(id: UUID = UUID(), title: String, description: String, icon: String, isUnlocked: Bool = false, unlockedDate: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
    }
    
    static let defaultAchievements: [Achievement] = [
        Achievement(title: "First Try-On", description: "Complete your first virtual try-on", icon: "star.fill"),
        Achievement(title: "5 Virtual Try-Ons", description: "Try on 5 different bags", icon: "star.circle.fill"),
        Achievement(title: "Collection Builder", description: "Save 10 bags to your collection", icon: "heart.fill"),
        Achievement(title: "Style Explorer", description: "Try bags from 3 different styles", icon: "sparkles"),
        Achievement(title: "Brand Enthusiast", description: "Try bags from 5 different brands", icon: "bag.fill")
    ]
}

struct UserStatistics {
    var totalTryOns: Int = 0
    var favoriteStyle: BagStyle?
    var favoriteBrand: String?
    var favoriteCategory: BagCategory?
    var totalBagsInCollection: Int = 0
    var averageRating: Double = 0.0
    
    mutating func updateFromSessions(_ sessions: [TryOnSession]) {
        totalTryOns = sessions.count
        
        let styleFrequency = Dictionary(grouping: sessions, by: { $0.style })
        favoriteStyle = styleFrequency.max(by: { $0.value.count < $1.value.count })?.key
        
        let brandFrequency = Dictionary(grouping: sessions, by: { $0.brand })
        favoriteBrand = brandFrequency.max(by: { $0.value.count < $1.value.count })?.key
        
        let categoryFrequency = Dictionary(grouping: sessions, by: { $0.category })
        favoriteCategory = categoryFrequency.max(by: { $0.value.count < $1.value.count })?.key
        
        let ratingsSum = sessions.compactMap { $0.rating }.reduce(0, +)
        let ratingsCount = sessions.compactMap { $0.rating }.count
        averageRating = ratingsCount > 0 ? Double(ratingsSum) / Double(ratingsCount) : 0.0
    }
}
