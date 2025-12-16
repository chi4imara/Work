import Foundation
import SwiftUI
import Combine

class ItemStore: ObservableObject {
    @Published var items: [Item] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var selectedCategories: Set<String> = []
    @Published var sortOption: SortOption = .dateDescending
    
    enum SortOption: String, CaseIterable {
        case dateDescending = "By Date ↓"
        case alphabetical = "A→Z"
    }
    
    private let itemsKey = "SavedItems"
    private let categoriesKey = "SavedCategories"
    
    init() {
        loadItems()
        loadCategories()
    }
        
    func addItem(_ item: Item) {
        items.append(item)
        saveItems()
    }
    
    func updateItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems()
        }
    }
    
    func deleteItem(_ item: Item) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func clearAllItems() {
        items.removeAll()
        saveItems()
    }
        
    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }
    
    func deleteCategory(_ category: Category) {
        let itemsInCategory = items.filter { $0.category == category.name }
        if itemsInCategory.isEmpty {
            categories.removeAll { $0.id == category.id }
            saveCategories()
        }
    }
    
    func itemCount(for category: Category) -> Int {
        return items.filter { $0.category == category.name }.count
    }
        
    var filteredAndSortedItems: [Item] {
        var result = items
        
        if !selectedCategories.isEmpty {
            result = result.filter { selectedCategories.contains($0.category) }
        }
        
        switch sortOption {
        case .dateDescending:
            result = result.sorted { $0.dateAdded > $1.dateAdded }
        case .alphabetical:
            result = result.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
        
        return result
    }
    
    var itemsWithStories: [Item] {
        return items.filter { !$0.story.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func resetFilter() {
        selectedCategories.removeAll()
    }
        
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: itemsKey)
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: itemsKey),
           let decoded = try? JSONDecoder().decode([Item].self, from: data) {
            items = decoded
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    private func loadCategories() {
        if let data = UserDefaults.standard.data(forKey: categoriesKey),
           let decoded = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decoded
        }
    }
}
