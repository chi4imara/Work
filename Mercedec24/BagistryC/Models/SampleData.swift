import Foundation

enum SampleData {
    
    static let sampleBags: [Bag] = {
        let bag1 = Bag(
            name: "Classic Tote",
            brand: "Luxury Brand",
            category: .tote,
            size: .large,
            price: 299.99,
            imageURL: "",
            color: "Black",
            style: .classic,
            isFavorite: true,
            description: "Perfect for everyday use"
        )
        let bag2 = Bag(
            name: "Evening Clutch",
            brand: "Designer Co",
            category: .clutch,
            size: .small,
            price: 149.99,
            imageURL: "",
            color: "Gold",
            style: .evening,
            isFavorite: true,
            description: "Elegant evening accessory"
        )
        let bag3 = Bag(
            name: "Crossbody Messenger",
            brand: "Urban Style",
            category: .crossbody,
            size: .medium,
            price: 199.99,
            imageURL: "",
            color: "Brown",
            style: .casual,
            isFavorite: false,
            description: "Comfortable daily companion"
        )
        let bag4 = Bag(
            name: "Travel Backpack",
            brand: "Adventure Gear",
            category: .backpack,
            size: .large,
            price: 249.99,
            imageURL: "",
            color: "Navy",
            style: .sporty,
            isFavorite: false,
            description: "Perfect for travel and outdoor activities"
        )
        let bag5 = Bag(
            name: "Mini Shoulder Bag",
            brand: "Chic Boutique",
            category: .shoulderBag,
            size: .small,
            price: 179.99,
            imageURL: "",
            color: "Pink",
            style: .trendy,
            isFavorite: true,
            description: "Trendy and compact design"
        )
        let bag6 = Bag(
            name: "Office Shopper",
            brand: "Luxury Brand",
            category: .shopper,
            size: .large,
            price: 319.99,
            imageURL: "",
            color: "Gray",
            style: .business,
            isFavorite: false,
            description: "Spacious bag for work"
        )
        return [bag1, bag2, bag3, bag4, bag5, bag6]
    }()
    
    static func sampleTryOnSessions(using bags: [Bag]) -> [TryOnSession] {
        guard bags.count >= 4 else { return [] }
        let calendar = Calendar.current
        let now = Date()
        
        return [
            TryOnSession(bag: bags[0], rating: 5, notes: "Perfect for work"),
            TryOnSession(bag: bags[1], rating: 4, notes: "Great for evening events"),
            TryOnSession(bag: bags[2], rating: 3, notes: "Nice but too small"),
            TryOnSession(bag: bags[3], rating: 5, notes: "Love it for travel"),
            TryOnSession(bag: bags[4], rating: 4, notes: "Cute and practical")
        ]
    }
    
    static var sampleUser: User {
        var user = User(
            name: "Sample User",
            email: "sample@example.com"
        )
        user.preferredSizes = [.medium, .large]
        user.favoriteBrands = ["Luxury Brand", "Designer Co", "Chic Boutique"]
        user.preferredStyles = [.casual, .classic, .evening]
        user.styleGoals = [.everyday, .evening, .travel]
        return user
    }
}
