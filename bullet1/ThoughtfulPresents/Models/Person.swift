import Foundation

struct Person: Identifiable, Equatable {
    let id: UUID
    let name: String
    let giftCount: Int
    let lastGift: String
    let totalAmount: Double
    
    init(name: String, giftCount: Int, lastGift: String, totalAmount: Double) {
        self.id = UUID()
        self.name = name
        self.giftCount = giftCount
        self.lastGift = lastGift
        self.totalAmount = totalAmount
    }
}

extension Person {
    static func createPeople(from giftIdeas: [GiftIdea]) -> [Person] {
        let groupedByName = Dictionary(grouping: giftIdeas) { $0.recipientName }
        
        return groupedByName.map { (name, gifts) in
            let giftCount = gifts.count
            let lastGift = gifts.max(by: { $0.dateAdded < $1.dateAdded })?.giftDescription ?? ""
            let totalAmount = gifts.compactMap { $0.estimatedPrice }.reduce(0, +)
            
            return Person(name: name, giftCount: giftCount, lastGift: lastGift, totalAmount: totalAmount)
        }.sorted { $0.name < $1.name }
    }
    
    static func topPeopleByAmount(from people: [Person], limit: Int = 3) -> [Person] {
        return people.sorted { $0.totalAmount > $1.totalAmount }.prefix(limit).map { $0 }
    }
}
