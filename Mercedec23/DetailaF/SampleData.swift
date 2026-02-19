import Foundation

enum SampleData {
    
    static func generate() -> (accessories: [Accessory], collections: [Collection], sessions: [TryOnSession]) {
        let accessories = sampleAccessories
        let collections = sampleCollections(accessories: accessories)
        let sessions = sampleSessions(accessories: accessories)
        return (accessories, collections, sessions)
    }
    
    private static var sampleAccessories: [Accessory] {
        [
            Accessory(
                name: "Classic Leather Handbag",
                brand: "Chanel",
                category: .bag,
                price: 2500,
                imageURL: "bag1",
                colors: ["Black", "Brown"],
                style: .classic,
                description: "Elegant leather handbag perfect for any occasion"
            ),
            Accessory(
                name: "Gold Chain Necklace",
                brand: "Tiffany & Co",
                category: .jewelry,
                price: 850,
                imageURL: "jewelry1",
                colors: ["Gold"],
                style: .evening,
                description: "Luxurious gold chain necklace"
            ),
            Accessory(
                name: "Designer Belt",
                brand: "Gucci",
                category: .belt,
                price: 450,
                imageURL: "belt1",
                colors: ["Black", "Brown"],
                style: .casual,
                description: "Stylish designer belt"
            ),
            Accessory(
                name: "Summer Hat",
                brand: "Hermès",
                category: .hat,
                price: 320,
                imageURL: "hat1",
                colors: ["Beige", "White"],
                style: .casual,
                description: "Perfect summer hat for sunny days"
            ),
            Accessory(
                name: "Evening Clutch",
                brand: "Prada",
                category: .bag,
                price: 1200,
                imageURL: "bag2",
                colors: ["Black", "Silver"],
                style: .evening,
                description: "Elegant evening clutch"
            ),
            Accessory(
                name: "Diamond Earrings",
                brand: "Cartier",
                category: .jewelry,
                price: 3200,
                imageURL: "jewelry2",
                colors: ["Silver"],
                style: .evening,
                description: "Stunning diamond earrings",
                isFavorite: true
            )
        ]
    }
    
    private static func sampleCollections(accessories: [Accessory]) -> [Collection] {
        let evening = Array(accessories.prefix(2))
        let casual = Array(accessories.suffix(2))
        return [
            Collection(name: "Evening Looks", accessories: evening, createdDate: Date()),
            Collection(name: "Casual Style", accessories: casual, createdDate: Date())
        ]
    }
    
    private static func sampleSessions(accessories: [Accessory]) -> [TryOnSession] {
        guard accessories.count >= 2 else { return [] }
        let a1 = accessories[0]
        let a2 = accessories[1]
        return [
            TryOnSession(
                accessoryId: a1.id,
                styleRawValue: a1.style.rawValue,
                colors: a1.colors,
                date: Date(),
                rating: 5,
                notes: "Perfect for work meetings"
            ),
            TryOnSession(
                accessoryId: a2.id,
                styleRawValue: a2.style.rawValue,
                colors: a2.colors,
                date: Date().addingTimeInterval(-86400),
                rating: 4,
                notes: "Great for evening events"
            )
        ]
    }
}
