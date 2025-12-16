import Foundation
import SwiftUI
import Combine

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var currentFilter: FilterType = .all
    @Published var selectedMonth: Date = Date()
    
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "SavedItems"
    
    init() {
        loadItems()
    }
    
    var filteredItems: [Item] {
        switch currentFilter {
        case .all:
            return items
        case .purchased:
            return items.filter { $0.status == .purchased }
        case .waiting:
            return items.filter { $0.status == .notPurchased }
        }
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    func addItem(_ item: Item) {
        items.append(item)
        saveItems()
    }
    
    func updateItem(_ updatedItem: Item) {
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            items[index] = updatedItem
            saveItems()
        }
    }
    
    func deleteItem(_ item: Item) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func toggleItemStatus(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if items[index].status == .notPurchased {
                items[index].markAsPurchased()
            } else {
                items[index].markAsNotPurchased()
            }
            saveItems()
        }
    }
    
    func setFilter(_ filter: FilterType) {
        currentFilter = filter
    }
    
    func getMonthlyAnalysis(for month: Date = Date()) -> MonthlyAnalysis {
        let calendar = Calendar.current
        let monthItems = items.filter { item in
            calendar.isDate(item.dateAdded, equalTo: month, toGranularity: .month)
        }
        
        let purchasedItems = monthItems.filter { $0.status == .purchased }
        let totalPlanned = monthItems.reduce(0) { $0 + $1.estimatedPrice }
        let actualSpent = purchasedItems.reduce(0) { $0 + $1.estimatedPrice }
        
        let highPriorityItems = monthItems.filter { $0.priority == .high }
        let mediumPriorityItems = monthItems.filter { $0.priority == .medium }
        let lowPriorityItems = monthItems.filter { $0.priority == .low }
        
        let impulsiveItems = purchasedItems.filter { $0.isImpulsive }
        let consciousItems = purchasedItems.filter { $0.isConscious }
        let unpurchasedNecessary = monthItems.filter { $0.status == .notPurchased && $0.priority == .high }
        
        return MonthlyAnalysis(
            month: month,
            totalItems: monthItems.count,
            purchasedItems: purchasedItems.count,
            plannedAmount: totalPlanned,
            actualSpent: actualSpent,
            highPriorityItems: highPriorityItems.count,
            highPriorityPurchased: highPriorityItems.filter { $0.status == .purchased }.count,
            mediumPriorityItems: mediumPriorityItems.count,
            mediumPriorityPurchased: mediumPriorityItems.filter { $0.status == .purchased }.count,
            lowPriorityItems: lowPriorityItems.count,
            lowPriorityPurchased: lowPriorityItems.filter { $0.status == .purchased }.count,
            impulsiveItems: impulsiveItems,
            consciousItems: consciousItems,
            unpurchasedNecessaryItems: unpurchasedNecessary
        )
    }
    
    func getMonthlySummary(for month: Date = Date()) -> MonthlySummary {
        let analysis = getMonthlyAnalysis(for: month)
        
        return MonthlySummary(
            consciousItems: analysis.consciousItems,
            impulsiveItems: analysis.impulsiveItems,
            unpurchasedNecessaryItems: analysis.unpurchasedNecessaryItems,
            consciousPercentage: analysis.consciousPercentage,
            impulsivePercentage: analysis.impulsivePercentage,
            totalSpent: analysis.actualSpent
        )
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            userDefaults.set(encoded, forKey: itemsKey)
        }
    }
    
    private func loadItems() {
        if let data = userDefaults.data(forKey: itemsKey),
           let decodedItems = try? JSONDecoder().decode([Item].self, from: data) {
            items = decodedItems
        }
    }
}
