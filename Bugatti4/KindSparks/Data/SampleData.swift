import Foundation

enum SampleData {
    
    static func generate() -> [Person] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today) ?? today
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: today) ?? today
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: today) ?? today
        let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: today) ?? today
        
        var alice = Person(name: "Alice")
        let aliceId = alice.id
        alice.ideas = [
            GiftIdea(text: "Wireless headphones", personId: aliceId, createdAt: today),
            GiftIdea(text: "Book by favorite author", personId: aliceId, createdAt: yesterday),
            GiftIdea(text: "Yoga mat", personId: aliceId, createdAt: twoDaysAgo),
            GiftIdea(text: "Scarf", personId: aliceId, createdAt: weekAgo),
            GiftIdea(text: "Coffee set", personId: aliceId, createdAt: monthAgo),
        ]
        
        var bob = Person(name: "Bob")
        let bobId = bob.id
        bob.ideas = [
            GiftIdea(text: "Running shoes", personId: bobId, createdAt: today),
            GiftIdea(text: "Watch strap", personId: bobId, createdAt: yesterday),
            GiftIdea(text: "Puzzle board game", personId: bobId, createdAt: weekAgo),
            GiftIdea(text: "Tool kit", personId: bobId, createdAt: twoWeeksAgo),
            GiftIdea(text: "Desk organizer", personId: bobId, createdAt: monthAgo),
            GiftIdea(text: "Backpack", personId: bobId, createdAt: twoMonthsAgo),
        ]
        
        var carol = Person(name: "Carol")
        let carolId = carol.id
        carol.ideas = [
            GiftIdea(text: "Perfume", personId: carolId, createdAt: yesterday),
            GiftIdea(text: "Plant pot", personId: carolId, createdAt: twoDaysAgo),
            GiftIdea(text: "Candle set", personId: carolId, createdAt: weekAgo),
        ]
        
        var david = Person(name: "David")
        let davidId = david.id
        david.ideas = [
            GiftIdea(text: "Gift card for bookstore", personId: davidId, createdAt: today),
            GiftIdea(text: "Phone stand", personId: davidId, createdAt: twoWeeksAgo),
        ]
        
        return [alice, bob, carol, david]
    }
}
