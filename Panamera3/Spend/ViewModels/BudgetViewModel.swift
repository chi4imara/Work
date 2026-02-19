import Foundation
import Combine

class BudgetViewModel: ObservableObject {
    @Published var budget = Budget()
    @Published var isFirstLaunch = true
    @Published var hasCompletedOnboarding = false
    @Published var searchText = ""
    @Published var selectedCategory = ""
    @Published var customCategories: [String] = []
    
    private let userDefaults = UserDefaults.standard
    private let budgetKey = "SavedBudget"
    private let onboardingKey = "HasCompletedOnboarding"
    private let customCategoriesKey = "CustomCategories"
    
    init() {
        loadBudget()
        loadOnboardingStatus()
        loadCustomCategories()
    }
    
    func setBudgetLimit(_ limit: Double) {
        budget.limit = limit
        saveBudget()
    }
    
    func addPurchase(_ purchase: Purchase) {
        budget.addPurchase(purchase)
        saveBudget()
    }
    
    func removePurchase(withId id: UUID) {
        budget.removePurchase(withId: id)
        saveBudget()
    }
    
    func updatePurchase(_ purchase: Purchase) {
        budget.updatePurchase(purchase)
        saveBudget()
    }
    
    func getPurchase(byId id: UUID) -> Purchase? {
        return budget.purchases.first { $0.id == id }
    }
    
    var allCategories: [String] {
        let defaultCategories = PurchaseCategory.allCases.map { $0.displayName }
        return defaultCategories + customCategories
    }
    
    func addCustomCategory(_ category: String) {
        if !customCategories.contains(category) && !PurchaseCategory.allCases.map({ $0.displayName }).contains(category) {
            customCategories.append(category)
            saveCustomCategories()
        }
    }
    
    var filteredPurchases: [Purchase] {
        var purchases = budget.purchases
        
        if !searchText.isEmpty {
            purchases = purchases.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if !selectedCategory.isEmpty && selectedCategory != "All" {
            purchases = purchases.filter { $0.category == selectedCategory }
        }
        
        return purchases.sorted { $0.date > $1.date }
    }
    
    var recentPurchases: [Purchase] {
        return Array(budget.purchases.sorted { $0.date > $1.date }.prefix(5))
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        isFirstLaunch = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    private func saveBudget() {
        if let encoded = try? JSONEncoder().encode(budget) {
            userDefaults.set(encoded, forKey: budgetKey)
        }
    }
    
    private func loadBudget() {
        if let data = userDefaults.data(forKey: budgetKey),
           let decoded = try? JSONDecoder().decode(Budget.self, from: data) {
            budget = decoded
            isFirstLaunch = false
        }
    }
    
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        if hasCompletedOnboarding {
            isFirstLaunch = false
        }
    }
    
    private func saveCustomCategories() {
        userDefaults.set(customCategories, forKey: customCategoriesKey)
    }
    
    private func loadCustomCategories() {
        customCategories = userDefaults.stringArray(forKey: customCategoriesKey) ?? []
    }
}
