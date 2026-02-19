import Foundation

enum SampleDataService {
    
    static func loadSampleData() {
        let bags = makeSampleBags()
        let user = makeSampleUser()
        let sessions = makeSampleTryOnSessions(bags: bags)
        let achievements = makeSampleAchievements(sessionCount: sessions.count, collectionCount: bags.filter(\.isFavorite).count)
        
        UserDefaultsStorage.shared.saveBags(bags)
        UserDefaultsStorage.shared.saveUser(user)
        UserDefaultsStorage.shared.saveTryOnSessions(sessions)
        UserDefaultsStorage.shared.saveAchievements(achievements)
    }
    
    private static func makeSampleBags() -> [Bag] {
        [
            Bag(
                name: "Classic Tote",
                brand: "Michael Kors",
                category: .tote,
                size: .large,
                price: 299,
                imageURL: "",
                color: "Black",
                style: .classic,
                isFavorite: true,
                description: "Timeless everyday tote."
            ),
            Bag(
                name: "Evening Clutch",
                brand: "Gucci",
                category: .clutch,
                size: .small,
                price: 890,
                imageURL: "",
                color: "Gold",
                style: .evening,
                isFavorite: true,
                description: "Elegant evening clutch."
            ),
            Bag(
                name: "Crossbody Daily",
                brand: "Coach",
                category: .crossbody,
                size: .medium,
                price: 245,
                imageURL: "",
                color: "Brown",
                style: .casual,
                isFavorite: false,
                description: "Perfect for everyday."
            ),
            Bag(
                name: "City Backpack",
                brand: "Longchamp",
                category: .backpack,
                size: .medium,
                price: 185,
                imageURL: "",
                color: "Navy",
                style: .sporty,
                isFavorite: true,
                description: "Lightweight city backpack."
            ),
            Bag(
                name: "Shoulder Bag",
                brand: "Furla",
                category: .shoulderBag,
                size: .medium,
                price: 320,
                imageURL: "",
                color: "Burgundy",
                style: .trendy,
                isFavorite: false,
                description: "Trendy shoulder bag."
            ),
            Bag(
                name: "Shopper",
                brand: "Michael Kors",
                category: .shopper,
                size: .large,
                price: 275,
                imageURL: "",
                color: "Beige",
                style: .business,
                isFavorite: false,
                description: "Spacious shopper bag."
            ),
            Bag(
                name: "Mini Crossbody",
                brand: "Coach",
                category: .crossbody,
                size: .small,
                price: 195,
                imageURL: "",
                color: "Pink",
                style: .casual,
                isFavorite: true,
                description: "Compact crossbody."
            ),
            Bag(
                name: "Leather Tote",
                brand: "Tory Burch",
                category: .tote,
                size: .medium,
                price: 450,
                imageURL: "",
                color: "Tan",
                style: .classic,
                isFavorite: false,
                description: "Premium leather tote."
            ),
            Bag(
                name: "Weekend Shopper",
                brand: "Longchamp",
                category: .shopper,
                size: .extraLarge,
                price: 165,
                imageURL: "",
                color: "Black",
                style: .casual,
                isFavorite: false,
                description: "Weekend and travel bag."
            ),
        ]
    }
    
    private static func makeSampleUser() -> User {
        User(
            name: "Sample User",
            email: "sample@example.com",
            avatar: nil,
            preferredSizes: [.medium, .small],
            favoriteBrands: ["Michael Kors", "Coach", "Longchamp"],
            preferredStyles: [.casual, .classic, .sporty],
            styleGoals: [.everyday, .travel],
            notificationSettings: NotificationSettings(newModels: true, discounts: true, stylistRecommendations: true, collectionUpdates: true)
        )
    }
    
    private static func makeSampleTryOnSessions(bags: [Bag]) -> [TryOnSession] {
        bags.prefix(6).enumerated().map { index, bag in
            TryOnSession(
                bag: bag,
                rating: min(5, 3 + index),
                notes: index == 0 ? "Loved it!" : nil
            )
        }
    }
    
    private static func makeSampleAchievements(sessionCount: Int, collectionCount: Int) -> [Achievement] {
        let defaults = Achievement.defaultAchievements
        let now = Date()
        
        return defaults.enumerated().map { index, achievement in
            var copy = achievement
            switch achievement.title {
            case "First Try-On":
                copy.isUnlocked = sessionCount >= 1
                copy.unlockedDate = sessionCount >= 1 ? now : nil
            case "5 Virtual Try-Ons":
                copy.isUnlocked = sessionCount >= 5
                copy.unlockedDate = sessionCount >= 5 ? now : nil
            case "Collection Builder":
                copy.isUnlocked = collectionCount >= 10
                copy.unlockedDate = collectionCount >= 10 ? now : nil
            case "Style Explorer":
                copy.isUnlocked = true
                copy.unlockedDate = now
            case "Brand Enthusiast":
                copy.isUnlocked = sessionCount >= 5
                copy.unlockedDate = sessionCount >= 5 ? now : nil
            default:
                break
            }
            return copy
        }
    }
}
