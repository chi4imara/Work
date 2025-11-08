import Foundation
import SwiftUI

class CollectionViewModel: ObservableObject {
    @Published var items: [CollectionItem] = []
    @Published var wishlistItems: [WishlistItem] = []
    @Published var transactions: [Transaction] = []
    @Published var sets: [CollectionSet] = []
    @Published var categories: [String] = ["Figures", "Stamps", "Comics", "Cards", "Coins", "Other"]
    @Published var conditions: [String] = ["Mint", "Near Mint", "Good", "Fair", "Poor"]
    @Published var searchText = ""
    @Published var selectedCategory = "All"
    @Published var sortOption: SortOption = .dateAdded
    @Published var showOnlyWithValue = false
    @Published var showDuplicatesOnly = false
    @Published var showForTradeOnly = false
    @Published var showNeedsVerification = false
    
    enum SortOption: String, CaseIterable {
        case nameAZ = "Name A-Z"
        case nameZA = "Name Z-A"
        case dateAdded = "Date Added ↓"
        case dateAddedAsc = "Date Added ↑"
        case year = "Year ↓"
        case yearAsc = "Year ↑"
        case value = "Value ↓"
        case valueAsc = "Value ↑"
        case condition = "Condition ↓"
        case conditionAsc = "Condition ↑"
    }
    
    init() {
        loadData()
    }
    
    var filteredItems: [CollectionItem] {
        var filtered = items
        
        if !searchText.isEmpty {
            filtered = filtered.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.series.localizedCaseInsensitiveContains(searchText) ||
                item.manufacturer.localizedCaseInsensitiveContains(searchText) ||
                item.number.localizedCaseInsensitiveContains(searchText) ||
                item.tags.joined().localizedCaseInsensitiveContains(searchText) ||
                item.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if showOnlyWithValue {
            filtered = filtered.filter { $0.hasValue }
        }
        
        if showDuplicatesOnly {
            filtered = filtered.filter { $0.isDuplicate }
        }
        
        if showForTradeOnly {
            filtered = filtered.filter { $0.isForTrade }
        }
        
        if showNeedsVerification {
            filtered = filtered.filter { $0.needsVerification }
        }
        
        return sortItems(filtered)
    }
    
    private func sortItems(_ items: [CollectionItem]) -> [CollectionItem] {
        switch sortOption {
        case .nameAZ:
            return items.sorted { $0.name < $1.name }
        case .nameZA:
            return items.sorted { $0.name > $1.name }
        case .dateAdded:
            return items.sorted { $0.dateAdded > $1.dateAdded }
        case .dateAddedAsc:
            return items.sorted { $0.dateAdded < $1.dateAdded }
        case .year:
            return items.sorted { ($0.year ?? 0) > ($1.year ?? 0) }
        case .yearAsc:
            return items.sorted { ($0.year ?? 0) < ($1.year ?? 0) }
        case .value:
            return items.sorted { ($0.currentValue ?? 0) > ($1.currentValue ?? 0) }
        case .valueAsc:
            return items.sorted { ($0.currentValue ?? 0) < ($1.currentValue ?? 0) }
        case .condition:
            return items.sorted { conditions.firstIndex(of: $0.condition) ?? 0 < conditions.firstIndex(of: $1.condition) ?? 0 }
        case .conditionAsc:
            return items.sorted { conditions.firstIndex(of: $0.condition) ?? 0 > conditions.firstIndex(of: $1.condition) ?? 0 }
        }
    }
    
    var tradeItems: [CollectionItem] {
        return items.filter { $0.isForTrade }
    }
    
    var statistics: CollectionStatistics {
        let totalItems = items.count
        let totalValue = items.compactMap { $0.currentValue }.reduce(0, +)
        let totalPurchasePrice = items.compactMap { $0.purchasePrice }.reduce(0, +)
        let duplicatesCount = items.filter { $0.isDuplicate }.count
        let categoryCounts = Dictionary(grouping: items, by: { $0.category }).mapValues { $0.count }
        
        return CollectionStatistics(
            totalItems: totalItems,
            totalValue: totalValue,
            totalPurchasePrice: totalPurchasePrice,
            profitLoss: totalValue - totalPurchasePrice,
            duplicatesCount: duplicatesCount,
            categoryCounts: categoryCounts
        )
    }
    
    func addItem(_ item: CollectionItem) {
        var newItem = item
        newItem.id = UUID() 
        items.append(newItem)
        saveData()
    }
    
    func updateItem(_ item: CollectionItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = item
            updatedItem.lastUpdated = Date()
            items[index] = updatedItem
            saveData()
        }
    }
    
    func deleteItem(_ item: CollectionItem) {
        items.removeAll { $0.id == item.id }
        saveData()
    }
    
    func addWishlistItem(_ item: WishlistItem) {
        var newItem = item
        newItem.id = UUID()
        wishlistItems.append(newItem)
        saveData()
    }
    
    func deleteWishlistItem(_ item: WishlistItem) {
        wishlistItems.removeAll { $0.id == item.id }
        saveData()
    }
    
    func updateWishlistItem(_ item: WishlistItem) {
        if let index = wishlistItems.firstIndex(where: { $0.id == item.id }) {
            print("Updating wishlist item at index \(index): \(item.name)")
            wishlistItems[index] = item
            saveData()
        } else {
            print("Warning: Could not find wishlist item with ID \(item.id) to update")
        }
    }
    
    func addTransaction(_ transaction: Transaction) {
        var newTransaction = transaction
        newTransaction.id = UUID()
        transactions.append(newTransaction)
        saveData()
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            print("Updating transaction at index \(index): \(transaction.itemName)")
            transactions[index] = transaction
            saveData()
        } else {
            print("Warning: Could not find transaction with ID \(transaction.id) to update")
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        saveData()
    }
    
    func addSet(_ set: CollectionSet) {
        var newSet = set
        newSet.id = UUID() 
        newSet.dateCreated = Date()
        sets.append(newSet)
        saveData()
    }
    
    func clearAllData() {
        items.removeAll()
        wishlistItems.removeAll()
        transactions.removeAll()
        sets.removeAll()
        saveData()
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "CollectionItems")
        }
        if let encoded = try? JSONEncoder().encode(wishlistItems) {
            UserDefaults.standard.set(encoded, forKey: "WishlistItems")
            print("Saved \(wishlistItems.count) wishlist items")
        }
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "Transactions")
            print("Saved \(transactions.count) transactions")
        }
        if let encoded = try? JSONEncoder().encode(sets) {
            UserDefaults.standard.set(encoded, forKey: "CollectionSets")
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "CollectionItems"),
           let decoded = try? JSONDecoder().decode([CollectionItem].self, from: data) {
            items = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "WishlistItems"),
           let decoded = try? JSONDecoder().decode([WishlistItem].self, from: data) {
            wishlistItems = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "Transactions"),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "CollectionSets"),
           let decoded = try? JSONDecoder().decode([CollectionSet].self, from: data) {
            sets = decoded
        }
    }
}

struct CollectionStatistics {
    let totalItems: Int
    let totalValue: Double
    let totalPurchasePrice: Double
    let profitLoss: Double
    let duplicatesCount: Int
    let categoryCounts: [String: Int]
    
    var averageValue: Double {
        guard totalItems > 0 else { return 0 }
        return totalValue / Double(totalItems)
    }
}
