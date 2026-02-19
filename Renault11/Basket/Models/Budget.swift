import Foundation

struct DailyBudget: Codable {
    var date: Date
    var limit: Double
    var spent: Double
    var purchases: [Purchase]
    
    var remaining: Double {
        return limit - spent
    }
    
    var progress: Double {
        return limit > 0 ? spent / limit : 0
    }
    
    init(date: Date = Date(), limit: Double = 1000.0) {
        self.date = date
        self.limit = limit
        self.spent = 0
        self.purchases = []
    }
}