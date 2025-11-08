import Foundation
import SwiftUI
import Combine

class ScentDiaryViewModel: ObservableObject {
    @Published var entries: [ScentEntry] = []
    @Published var categories: [String] = AppConstants.defaultCategories
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .dateNewest
    @Published var showingAddEntry = false
    @Published var selectedEntry: ScentEntry?
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = AppConstants.UserDefaultsKeys.scentEntries
    private let categoriesKey = AppConstants.UserDefaultsKeys.scentCategories
    
    init() {
        loadData()
    }
    
    func loadData() {
        loadEntries()
        loadCategories()
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([ScentEntry].self, from: data) {
            entries = decodedEntries
        }
    }
    
    private func loadCategories() {
        if let savedCategories = userDefaults.array(forKey: categoriesKey) as? [String] {
            categories = savedCategories
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func saveCategories() {
        userDefaults.set(categories, forKey: categoriesKey)
    }
    
    func addEntry(_ entry: ScentEntry) {
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: ScentEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: ScentEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteAllEntries() {
        entries.removeAll()
        saveEntries()
    }
    
    func addCategory(_ category: String) {
        if !categories.contains(category) && !category.isEmpty {
            categories.append(category)
            categories.sort()
            saveCategories()
        }
    }
    
    func updateCategory(oldName: String, newName: String) {
        if let index = categories.firstIndex(of: oldName) {
            categories[index] = newName
            categories.sort()
            saveCategories()
        }
    }
    
    func deleteCategory(_ category: String) {
        categories.removeAll { $0 == category }
        saveCategories()
    }
    
    var filteredEntries: [ScentEntry] {
        let filtered = searchText.isEmpty ? entries : entries.filter { entry in
            entry.name.localizedCaseInsensitiveContains(searchText) ||
            entry.associations.localizedCaseInsensitiveContains(searchText)
        }
        
        return sortedEntries(filtered)
    }
    
    private func sortedEntries(_ entries: [ScentEntry]) -> [ScentEntry] {
        switch sortOption {
        case .dateNewest:
            return entries.sorted { $0.dateAdded > $1.dateAdded }
        case .alphabetical:
            return entries.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .category:
            return entries.sorted { $0.category.localizedCaseInsensitiveCompare($1.category) == .orderedAscending }
        }
    }
    
    func setSortOption(_ option: SortOption) {
        sortOption = option
    }
}
