import Foundation
import SwiftUI
import Combine

class EntryStore: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var categories: [Category] = Category.defaultCases
    @Published var customCategories: [Category] = []
    @Published var filterPeriod: FilterPeriod = .all
    @Published var sortOrder: SortOrder = .newest
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "SavedEntries"
    private let customCategoriesKey = "CustomCategories"
    
    enum FilterPeriod: String, CaseIterable {
        case all = "All"
        case week = "Week"
        case month = "Month"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    enum SortOrder: String, CaseIterable {
        case newest = "Newest First"
        case oldest = "Oldest First"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    var allCategories: [Category] {
        return (categories + customCategories).sorted { category1, category2 in
            if !category1.isCustom && category2.isCustom {
                return true
            }
            if category1.isCustom && !category2.isCustom {
                return false
            }
            return category1.displayName < category2.displayName
        }
    }
    
    init() {
        loadEntries()
        loadCustomCategories()
    }
    
    func addEntry(_ entry: Entry) {
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: Entry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: Entry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteEntry(at indexSet: IndexSet) {
        entries.remove(atOffsets: indexSet)
        saveEntries()
    }
    
    var filteredAndSortedEntries: [Entry] {
        let filtered = filteredEntries
        return sortedEntries(filtered)
    }
    
    private var filteredEntries: [Entry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch filterPeriod {
        case .all:
            return entries
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return entries.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return entries.filter { $0.date >= monthAgo }
        }
    }
    
    private func sortedEntries(_ entries: [Entry]) -> [Entry] {
        switch sortOrder {
        case .newest:
            return entries.sorted { $0.date > $1.date }
        case .oldest:
            return entries.sorted { $0.date < $1.date }
        }
    }
    
    func entriesForCategory(_ category: Category) -> [Entry] {
        return entries.filter { $0.category == category }
    }
    
    func categoryStatistics() -> [CategoryStat] {
        let categoryGroups = Dictionary(grouping: entries) { $0.category }
        return categoryGroups.map { category, entries in
            CategoryStat(category: category, count: entries.count)
        }.sorted { $0.count > $1.count }
    }
    
    func recentEntries(limit: Int = 5) -> [Entry] {
        return entries.sorted { $0.date > $1.date }.prefix(limit).map { $0 }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = decoded
        }
    }
    
    func resetFilters() {
        filterPeriod = .all
        sortOrder = .newest
    }
    
    func addCustomCategory(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let existingNames = allCategories.map { $0.displayName.lowercased() }
        guard !existingNames.contains(trimmedName.lowercased()) else { return }
        
        let newCategory = Category.custom(trimmedName)
        customCategories.append(newCategory)
        saveCustomCategories()
    }
    
    func deleteCustomCategory(_ category: Category) {
        guard category.isCustom else { return }
        
        let hasEntries = entries.contains { $0.category == category }
        guard !hasEntries else { return }
        
        customCategories.removeAll { $0 == category }
        saveCustomCategories()
    }
    
    func renameCustomCategory(_ category: Category, to newName: String) {
        guard category.isCustom else { return }
        
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let existingNames = allCategories.filter { $0 != category }.map { $0.displayName.lowercased() }
        guard !existingNames.contains(trimmedName.lowercased()) else { return }
        
        let newCategory = Category.custom(trimmedName)
        
        for i in entries.indices {
            if entries[i].category == category {
                entries[i].category = newCategory
            }
        }
        
        if let index = customCategories.firstIndex(of: category) {
            customCategories[index] = newCategory
        }
        
        saveEntries()
        saveCustomCategories()
    }
    
    private func saveCustomCategories() {
        if let encoded = try? JSONEncoder().encode(customCategories) {
            userDefaults.set(encoded, forKey: customCategoriesKey)
        }
    }
    
    private func loadCustomCategories() {
        if let data = userDefaults.data(forKey: customCategoriesKey),
           let decoded = try? JSONDecoder().decode([Category].self, from: data) {
            customCategories = decoded
        }
    }
}

struct CategoryStat: Identifiable {
    let id = UUID()
    let category: Category
    let count: Int
}
