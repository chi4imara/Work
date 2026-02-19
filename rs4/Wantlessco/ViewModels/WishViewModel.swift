import Foundation
import SwiftUI
import Combine

class WishViewModel: ObservableObject {
    @Published var entries: [WishEntry] = []
    @Published var categories: [Category] = []
    @Published var isFirstLaunch: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "WishEntries"
    private let categoriesKey = "WishCategories"
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        loadCategories()
        loadEntries()
        checkFirstLaunch()
    }
    
    func addEntry(_ entry: WishEntry) {
        var entryToAdd = entry
        if entryToAdd.categoryId == nil {
            entryToAdd.categoryId = getUncategorizedCategoryId()
        }
        entries.append(entryToAdd)
        saveEntries()
    }
    
    func updateEntry(_ entry: WishEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            var entryToUpdate = entry
            if entryToUpdate.categoryId == nil {
                entryToUpdate.categoryId = getUncategorizedCategoryId()
            }
            entries[index] = entryToUpdate
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: WishEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteEntry(at indexSet: IndexSet) {
        entries.remove(atOffsets: indexSet)
        saveEntries()
    }
    
    func getEntry(by id: UUID) -> WishEntry? {
        return entries.first { $0.id == id }
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
        }
    }
    
    func deleteCategory(_ category: Category) {
        guard category.name != "Uncategorized" else { return }
        let uncategorizedId = getUncategorizedCategoryId()
        categories.removeAll { $0.id == category.id }
        entries = entries.map { entry in
            var updatedEntry = entry
            if entry.categoryId == category.id {
                updatedEntry.categoryId = uncategorizedId
            }
            return updatedEntry
        }
        saveCategories()
        saveEntries()
    }
    
    func getCategory(by id: UUID) -> Category? {
        return categories.first { $0.id == id }
    }
    
    func getEntries(for categoryId: UUID) -> [WishEntry] {
        return entries.filter { $0.categoryId == categoryId }
    }
    
    func getUncategorizedEntries() -> [WishEntry] {
        let uncategorizedId = getUncategorizedCategoryId()
        return entries.filter { $0.categoryId == uncategorizedId }
    }
    
    func getUncategorizedCategoryId() -> UUID {
        if let uncategorized = categories.first(where: { $0.name == "Uncategorized" }) {
            return uncategorized.id
        } else {
            let uncategorized = Category(name: "Uncategorized", color: .teal)
            categories.insert(uncategorized, at: 0)
            saveCategories()
            return uncategorized.id
        }
    }
    
    var wantCount: Int {
        entries.filter { $0.type == .want }.count
    }
    
    var dontWantCount: Int {
        entries.filter { $0.type == .dontWant }.count
    }
    
    var totalCount: Int {
        entries.count
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        userDefaults.set(false, forKey: firstLaunchKey)
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([WishEntry].self, from: data) {
            entries = decodedEntries
            migrateEntriesToUncategorized()
        }
    }
    
    private func migrateEntriesToUncategorized() {
        let uncategorizedId = getUncategorizedCategoryId()
        var needsSave = false
        
        entries = entries.map { entry in
            if entry.categoryId == nil {
                needsSave = true
                var updatedEntry = entry
                updatedEntry.categoryId = uncategorizedId
                return updatedEntry
            }
            return entry
        }
        
        if needsSave {
            saveEntries()
        }
    }
    
    private func saveEntries() {
        if let encodedData = try? JSONEncoder().encode(entries) {
            userDefaults.set(encodedData, forKey: entriesKey)
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    private func loadCategories() {
        if let data = userDefaults.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decodedCategories
            ensureUncategorizedCategory()
        } else {
            createDefaultCategories()
        }
    }
    
    private func saveCategories() {
        if let encodedData = try? JSONEncoder().encode(categories) {
            userDefaults.set(encodedData, forKey: categoriesKey)
        }
    }
    
    private func createDefaultCategories() {
        let defaultCategories = [
            Category(name: "Uncategorized", color: .teal),
            Category(name: "Work", color: .blue),
            Category(name: "Personal", color: .purple),
            Category(name: "Health", color: .green),
            Category(name: "Relationships", color: .pink),
            Category(name: "Hobbies", color: .orange)
        ]
        categories = defaultCategories
        saveCategories()
    }
    
    private func ensureUncategorizedCategory() {
        if categories.first(where: { $0.name == "Uncategorized" }) == nil {
            let uncategorized = Category(name: "Uncategorized", color: .teal)
            categories.insert(uncategorized, at: 0)
            saveCategories()
        }
    }
}
