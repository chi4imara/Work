import Foundation

enum SampleData {
    
    static func makeSampleItems() -> [WardrobeItem] {
        [
            WardrobeItem(name: "Winter Coat", category: "Outerwear", color: "Black", size: "M", comment: "Warm wool coat"),
            WardrobeItem(name: "Denim Jacket", category: "Outerwear", color: "Blue", size: "S"),
            WardrobeItem(name: "White Sneakers", category: "Shoes", color: "White", size: "38"),
            WardrobeItem(name: "Ankle Boots", category: "Shoes", color: "Brown", size: "37"),
            WardrobeItem(name: "Leather Belt", category: "Accessories", color: "Brown"),
            WardrobeItem(name: "Silver Watch", category: "Accessories", color: "Silver"),
            WardrobeItem(name: "Floral Dress", category: "Dresses", color: "Multicolor", size: "M"),
            WardrobeItem(name: "Black Dress", category: "Dresses", color: "Black", size: "S", comment: "Evening wear"),
            WardrobeItem(name: "White Blouse", category: "Blouses", color: "White", size: "M"),
            WardrobeItem(name: "Striped Blouse", category: "Blouses", color: "Navy", size: "S"),
            WardrobeItem(name: "Silk Scarf", category: "Accessories", color: "Red"),
            WardrobeItem(name: "High Heels", category: "Shoes", color: "Black", size: "36"),
        ]
    }
    
    static func makeSampleOutfits(items: [WardrobeItem]) -> [Outfit] {
        let calendar = Calendar.current
        let today = Date()
        
        guard items.count >= 4 else { return [] }
        
        let outfit1 = Outfit(
            name: "Casual Day",
            items: Array(items.prefix(3)),
            category: "Casual",
            dateCreated: calendar.date(byAdding: .day, value: -2, to: today) ?? today
        )
        
        let outfit2 = Outfit(
            name: "Office Look",
            items: [items[6], items[8], items[4], items[2]],
            category: "Work",
            dateCreated: calendar.date(byAdding: .day, value: -1, to: today) ?? today
        )
        
        let outfit3 = Outfit(
            name: "Weekend Style",
            items: [items[1], items[9], items[0]],
            category: "Casual",
            dateCreated: today
        )
        
        let outfit4 = Outfit(
            name: "Evening Out",
            items: [items[7], items[11], items[5]],
            category: "Evening",
            dateCreated: calendar.date(byAdding: .day, value: -5, to: today) ?? today
        )
        
        return [outfit1, outfit2, outfit3, outfit4]
    }
    
    static var sampleItems: [WardrobeItem] { makeSampleItems() }
    
    static var sampleOutfits: [Outfit] {
        makeSampleOutfits(items: sampleItems)
    }
}
