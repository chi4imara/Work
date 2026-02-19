import Foundation
import SwiftUI
import Combine

class ItemsViewModel: ObservableObject {
    @Published var itemSets: [ItemSet] = []
    @Published var currentSetIndex: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let itemSetsKey = "ItemSets"
    private let currentSetIndexKey = "CurrentSetIndex"
    
    init() {
        loadData()
        if itemSets.isEmpty {
            setupDefaultSets()
        }
    }
    
    var currentSet: ItemSet {
        guard currentSetIndex < itemSets.count else {
            return ItemSet(name: "Main Set")
        }
        return itemSets[currentSetIndex]
    }
    
    var currentItems: [Item] {
        return currentSet.items
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(itemSets) {
            userDefaults.set(encoded, forKey: itemSetsKey)
        }
        userDefaults.set(currentSetIndex, forKey: currentSetIndexKey)
    }
    
    private func loadData() {
        if let data = userDefaults.data(forKey: itemSetsKey),
           let decodedSets = try? JSONDecoder().decode([ItemSet].self, from: data) {
            itemSets = decodedSets
        }
        currentSetIndex = userDefaults.integer(forKey: currentSetIndexKey)
    }
    
    private func setupDefaultSets() {
        itemSets = ItemSet.defaultSets
        saveData()
    }
    
    func addItem(_ item: Item) {
        itemSets[currentSetIndex].items.append(item)
        saveData()
    }
    
    func updateItem(_ oldItem: Item, with newItem: Item) {
        for setIndex in itemSets.indices {
            if let index = itemSets[setIndex].items.firstIndex(where: { $0.id == oldItem.id }) {
                itemSets[setIndex].items[index] = Item(
                    id: oldItem.id,
                    name: newItem.name,
                    category: newItem.category,
                    note: newItem.note,
                    isInBag: newItem.isInBag,
                    createdAt: oldItem.createdAt
                )
                saveData()
                return
            }
        }
    }
    
    func updateItem(_ item: Item) {
        for setIndex in itemSets.indices {
            if let index = itemSets[setIndex].items.firstIndex(where: { $0.id == item.id }) {
                itemSets[setIndex].items[index] = item
                saveData()
                return
            }
        }
    }
    
    func deleteItem(_ item: Item) {
        for setIndex in itemSets.indices {
            itemSets[setIndex].items.removeAll { $0.id == item.id }
        }
        saveData()
    }
    
    func toggleItemInBag(_ item: Item) {
        for setIndex in itemSets.indices {
            if let index = itemSets[setIndex].items.firstIndex(where: { $0.id == item.id }) {
                itemSets[setIndex].items[index].isInBag.toggle()
                saveData()
                return
            }
        }
    }
    
    func switchToSet(at index: Int) {
        guard index < itemSets.count else { return }
        currentSetIndex = index
        saveData()
    }
    
    func createNewSet(name: String) {
        let newSet = ItemSet(name: name)
        itemSets.append(newSet)
        currentSetIndex = itemSets.count - 1
        saveData()
    }
    
    func getItemsByCategory() -> [ItemCategory: [Item]] {
        var categorizedItems: [ItemCategory: [Item]] = [:]
        
        for itemSet in itemSets {
            for item in itemSet.items {
                if categorizedItems[item.category] == nil {
                    categorizedItems[item.category] = []
                }
                categorizedItems[item.category]?.append(item)
            }
        }
        
        return categorizedItems
    }
    
    func getItemsForCategory(_ category: ItemCategory) -> [Item] {
        var items: [Item] = []
        for itemSet in itemSets {
            items.append(contentsOf: itemSet.items.filter { $0.category == category })
        }
        return items
    }
    
    func getItemById(_ id: UUID) -> Item? {
        for itemSet in itemSets {
            if let item = itemSet.items.first(where: { $0.id == id }) {
                return item
            }
        }
        return nil
    }
    
    func getItemSetIndex(containing itemId: UUID) -> Int? {
        for (index, itemSet) in itemSets.enumerated() {
            if itemSet.items.contains(where: { $0.id == itemId }) {
                return index
            }
        }
        return nil
    }
}
