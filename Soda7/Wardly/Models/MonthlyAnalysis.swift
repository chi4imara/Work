import Foundation

struct MonthlyAnalysis {
    let month: Date
    let totalItems: Int
    let purchasedItems: Int
    let plannedAmount: Double
    let actualSpent: Double
    let highPriorityItems: Int
    let highPriorityPurchased: Int
    let mediumPriorityItems: Int
    let mediumPriorityPurchased: Int
    let lowPriorityItems: Int
    let lowPriorityPurchased: Int
    let impulsiveItems: [Item]
    let consciousItems: [Item]
    let unpurchasedNecessaryItems: [Item]
    
    var consciousPercentage: Double {
        guard purchasedItems > 0 else { return 0 }
        return Double(consciousItems.count) / Double(purchasedItems) * 100
    }
    
    var impulsivePercentage: Double {
        guard purchasedItems > 0 else { return 0 }
        return Double(impulsiveItems.count) / Double(purchasedItems) * 100
    }
    
    var savingsAmount: Double {
        return plannedAmount - actualSpent
    }
}

struct MonthlySummary {
    let consciousItems: [Item]
    let impulsiveItems: [Item]
    let unpurchasedNecessaryItems: [Item]
    let consciousPercentage: Double
    let impulsivePercentage: Double
    let totalSpent: Double
    
    var hasData: Bool {
        return !consciousItems.isEmpty || !impulsiveItems.isEmpty
    }
}
