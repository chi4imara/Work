import Foundation
import SwiftUI
import Combine

class JewelryStore: ObservableObject {
    @Published var items: [JewelryItem] = []
    @Published var customCategories: [CustomCategory] = []
    
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "jewelry_items"
    private let categoriesKey = "custom_categories"
    
    init() {
        loadData()
    }
    
    func addItem(_ item: JewelryItem) {
        items.append(item)
        saveData()
    }
    
    func updateItem(_ item: JewelryItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveData()
        }
    }
    
    func deleteItem(_ item: JewelryItem) {
        items.removeAll { $0.id == item.id }
        saveData()
    }
    
    func markAsWornToday(_ item: JewelryItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].lastWornDate = Date()
            saveData()
        }
    }
    
    func addCustomCategory(_ name: String) {
        let category = CustomCategory(name: name)
        customCategories.append(category)
        saveData()
    }
    
    func getAllCategories() -> [String] {
        var categories = JewelryCategory.allCases.map { $0.rawValue }
        categories.append(contentsOf: customCategories.map { $0.name })
        return categories
    }
    
    func getItemsByCategory(_ categoryName: String) -> [JewelryItem] {
        return items.filter { item in
            if let category = JewelryCategory(rawValue: categoryName) {
                return item.category == category
            } else {
                return item.category == .custom && item.customCategoryName == categoryName
            }
        }
    }
    
    func getRecentItems() -> [JewelryItem] {
        return items
            .filter { $0.hasBeenWorn }
            .sorted { ($0.lastWornDate ?? Date.distantPast) > ($1.lastWornDate ?? Date.distantPast) }
    }
    
    func getCategoryCounts() -> [(String, Int)] {
        let allCategories = getAllCategories()
        return allCategories.map { category in
            (category, getItemsByCategory(category).count)
        }.filter { $0.1 > 0 }
    }
    
    func getItem(by id: UUID) -> JewelryItem? {
        return items.first { $0.id == id }
    }
    
    private func saveData() {
        if let itemsData = try? JSONEncoder().encode(items) {
            userDefaults.set(itemsData, forKey: itemsKey)
        }
        
        if let categoriesData = try? JSONEncoder().encode(customCategories) {
            userDefaults.set(categoriesData, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        if let itemsData = userDefaults.data(forKey: itemsKey),
           let decodedItems = try? JSONDecoder().decode([JewelryItem].self, from: itemsData) {
            items = decodedItems
        }
        
        if let categoriesData = userDefaults.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([CustomCategory].self, from: categoriesData) {
            customCategories = decodedCategories
        }
    }
}
