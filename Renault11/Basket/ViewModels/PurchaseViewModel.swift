import Foundation
import SwiftUI
import Combine

private enum StorageKey {
    static let purchases = "SavedPurchases"
    static let dailyBudgetLimit = "DailyBudgetLimit"
}

class PurchaseViewModel: ObservableObject {
    @Published var purchases: [Purchase] = [] {
        didSet { savePurchases() }
    }
    @Published var dailyBudget: DailyBudget = DailyBudget() {
        didSet { saveBudgetLimit() }
    }
    @Published var selectedDate: Date = Date()
    
    init() {
        loadFromUserDefaults()
    }
    
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: StorageKey.purchases),
           let decoded = try? JSONDecoder().decode([Purchase].self, from: data) {
            purchases = decoded
        } else {
        }
        
        if let limit = UserDefaults.standard.object(forKey: StorageKey.dailyBudgetLimit) as? Double {
            dailyBudget.limit = limit
        }
        updateDailyBudget()
    }
    
    private func savePurchases() {
        guard let data = try? JSONEncoder().encode(purchases) else { return }
        UserDefaults.standard.set(data, forKey: StorageKey.purchases)
    }
    
    private func saveBudgetLimit() {
        UserDefaults.standard.set(dailyBudget.limit, forKey: StorageKey.dailyBudgetLimit)
    }
    
    func addPurchase(_ purchase: Purchase) {
        purchases.append(purchase)
        updateDailyBudget()
    }
    
    func updatePurchase(_ purchase: Purchase) {
        if let index = purchases.firstIndex(where: { $0.id == purchase.id }) {
            purchases[index] = purchase
            updateDailyBudget()
        }
    }
    
    func deletePurchase(_ purchase: Purchase) {
        purchases.removeAll { $0.id == purchase.id }
        updateDailyBudget()
    }
    
    func completePurchase(_ purchase: Purchase, actualAmount: Double) {
        if let index = purchases.firstIndex(where: { $0.id == purchase.id }) {
            purchases[index].isCompleted = true
            purchases[index].actualAmount = actualAmount
            updateDailyBudget()
        }
    }
    
    func updateDailyBudget() {
        let today = Calendar.current.startOfDay(for: Date())
        let todayPurchases = purchases.filter { 
            Calendar.current.isDate($0.date, inSameDayAs: today) && $0.isCompleted 
        }
        
        dailyBudget.purchases = todayPurchases
        dailyBudget.spent = todayPurchases.reduce(0) { $0 + ($1.actualAmount ?? $1.plannedAmount) }
        dailyBudget.date = today
    }
    
    func setBudgetLimit(_ limit: Double) {
        dailyBudget.limit = limit
    }
    
    func purchasesForDate(_ date: Date) -> [Purchase] {
        return purchases.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func purchasesForCategory(_ category: PurchaseCategory) -> [Purchase] {
        return purchases.filter { $0.category == category }
    }
    
    func completedPurchases() -> [Purchase] {
        return purchases.filter { $0.isCompleted }
    }
    
    func pendingPurchases() -> [Purchase] {
        return purchases.filter { !$0.isCompleted }
    }
    
    func totalSpentThisMonth() -> Double {
        let calendar = Calendar.current
        let now = Date()
        let monthPurchases = purchases.filter { 
            calendar.isDate($0.date, equalTo: now, toGranularity: .month) && $0.isCompleted
        }
        return monthPurchases.reduce(0) { $0 + ($1.actualAmount ?? $1.plannedAmount) }
    }
    
    func purchasesByCategory() -> [PurchaseCategory: [Purchase]] {
        return Dictionary(grouping: purchases, by: { $0.category })
    }
    
    func loadSampleDataForTesting() {
        let calendar = Calendar.current
        let today = Date()
        
        var samplePurchases: [Purchase] = [
            Purchase(name: "New Dress", category: .clothing, plannedAmount: 150.0, notes: "For the party"),
            Purchase(name: "Lipstick", category: .cosmetics, plannedAmount: 45.0),
            Purchase(name: "Kitchen Towels", category: .home, plannedAmount: 25.0),
            Purchase(name: "Birthday Gift", category: .gifts, plannedAmount: 80.0, notes: "For Sarah"),
            Purchase(name: "Winter Coat", category: .clothing, plannedAmount: 220.0, notes: "Sale item"),
            Purchase(name: "Face Cream", category: .cosmetics, plannedAmount: 35.0),
            Purchase(name: "Cushions", category: .home, plannedAmount: 60.0),
            Purchase(name: "Anniversary Gift", category: .gifts, plannedAmount: 120.0),
            Purchase(name: "Running Shoes", category: .clothing, plannedAmount: 95.0),
            Purchase(name: "Perfume", category: .cosmetics, plannedAmount: 78.0, notes: "Best buy"),
        ]
        
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
           let lastWeek = calendar.date(byAdding: .day, value: -7, to: today) {
            samplePurchases[0].date = today
            samplePurchases[1].date = today
            samplePurchases[2].date = yesterday
            samplePurchases[3].date = yesterday
            samplePurchases[4].date = lastWeek
            samplePurchases[5].date = lastWeek
            samplePurchases[6].date = today
            samplePurchases[7].date = lastWeek
            samplePurchases[8].date = today
            samplePurchases[9].date = yesterday
        }
        
        samplePurchases[0].isCompleted = true
        samplePurchases[0].actualAmount = 140.0
        samplePurchases[2].isCompleted = true
        samplePurchases[2].actualAmount = 22.0
        samplePurchases[4].isCompleted = true
        samplePurchases[4].actualAmount = 199.0
        samplePurchases[6].isCompleted = true
        samplePurchases[6].actualAmount = 55.0
        samplePurchases[9].isCompleted = true
        samplePurchases[9].actualAmount = 75.0
        
        purchases = samplePurchases
        dailyBudget.limit = 1000.0
        updateDailyBudget()
    }
}
