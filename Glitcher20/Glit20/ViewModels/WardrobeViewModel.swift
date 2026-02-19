import Foundation
import SwiftUI
import Combine

class WardrobeViewModel: ObservableObject {
    @Published var items: [WardrobeItem] = []
    @Published var categories: [Category] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All Categories"
    
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "WardrobeItems"
    
    init() {
        loadItems()
        updateCategories()
    }
        
    func addItem(_ item: WardrobeItem) {
        items.append(item)
        saveItems()
        updateCategories()
    }
    
    func updateItem(_ item: WardrobeItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems()
            updateCategories()
        }
    }
    
    func deleteItem(_ item: WardrobeItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
        updateCategories()
    }
    
    func deleteItem(by id: UUID) {
        items.removeAll { $0.id == id }
        saveItems()
        updateCategories()
    }
    
    func togglePurchased(_ item: WardrobeItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isPurchased.toggle()
            saveItems()
        }
    }
        
    var filteredItems: [WardrobeItem] {
        var filtered = items
        
        if !searchText.isEmpty {
            filtered = filtered.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedCategory != "All Categories" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        return filtered.sorted { $0.createdAt > $1.createdAt }
    }
    
    var purchasedItems: [WardrobeItem] {
        return items.filter { $0.isPurchased }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func itemsInCategory(_ categoryName: String) -> [WardrobeItem] {
        return items.filter { $0.category == categoryName }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getItem(by id: UUID) -> WardrobeItem? {
        return items.first { $0.id == id }
    }
        
    private func updateCategories() {
        let categoryNames = Set(items.map { $0.category })
        categories = categoryNames.map { name in
            let count = items.filter { $0.category == name }.count
            return Category(name: name, itemCount: count)
        }.sorted { $0.name < $1.name }
    }
    
    var allCategoryNames: [String] {
        var names = ["All Categories"]
        names.append(contentsOf: categories.map { $0.name })
        return names
    }
        
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            userDefaults.set(encoded, forKey: itemsKey)
        }
    }
    
    private func loadItems() {
        if let data = userDefaults.data(forKey: itemsKey),
           let decoded = try? JSONDecoder().decode([WardrobeItem].self, from: data) {
            items = decoded
        }
    }
}
