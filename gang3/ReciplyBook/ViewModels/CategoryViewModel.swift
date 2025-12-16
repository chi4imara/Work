import Foundation
import SwiftUI
import Combine

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var showingAddCategory = false
    @Published var editingCategory: Category?
    
    private let userDefaults = UserDefaults.standard
    private let categoriesKey = "SavedCategories"
    
    init() {
        loadCategories()
        if categories.isEmpty {
            categories = Category.defaultCategories
            saveCategories()
        }
    }
    
    var sortedCategories: [Category] {
        categories.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }
    
    func addCategory(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else { return false }
        guard !categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else { return false }
        
        let newCategory = Category(name: trimmedName)
        categories.append(newCategory)
        saveCategories()
        return true
    }
    
    func updateCategory(_ category: Category, newName: String) -> Bool {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else { return false }
        guard !categories.contains(where: { $0.id != category.id && $0.name.lowercased() == trimmedName.lowercased() }) else { return false }
        
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].name = trimmedName
            saveCategories()
            return true
        }
        return false
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        saveCategories()
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            userDefaults.set(encoded, forKey: categoriesKey)
        }
    }
    
    private func loadCategories() {
        if let data = userDefaults.data(forKey: categoriesKey),
           let decoded = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decoded
        }
    }
}
