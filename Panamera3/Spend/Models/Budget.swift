import Foundation

struct Budget: Codable {
    var limit: Double
    var spent: Double {
        return purchases.reduce(0) { $0 + $1.amount }
    }
    var remaining: Double {
        return limit - spent
    }
    var purchases: [Purchase]
    
    init(limit: Double = 0.0, purchases: [Purchase] = []) {
        self.limit = limit
        self.purchases = purchases
    }
    
    mutating func addPurchase(_ purchase: Purchase) {
        purchases.append(purchase)
    }
    
    mutating func removePurchase(withId id: UUID) {
        purchases.removeAll { $0.id == id }
    }
    
    mutating func updatePurchase(_ purchase: Purchase) {
        if let index = purchases.firstIndex(where: { $0.id == purchase.id }) {
            purchases[index] = purchase
        }
    }
}
