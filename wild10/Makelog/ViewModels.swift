import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var appState: AppState = .splash
    @Published var hasSeenOnboarding: Bool = false
    
    init() {
        checkOnboardingStatus()
    }
    
    private func checkOnboardingStatus() {
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        hasSeenOnboarding = true
        appState = .main
    }
    
    func completeSplash() {
        if hasSeenOnboarding {
            appState = .main
        } else {
            appState = .onboarding
        }
    }
}

class WeatherEntriesViewModel: ObservableObject {
    @Published var entries: [WeatherEntry] = []
    @Published var categories: [WeatherCategory] = WeatherCategory.defaultCategories
    @Published var filterState = FilterState()
    @Published var isShowingCreateEntry = false
    @Published var isShowingCategoryFilter = false
    @Published var isShowingSortOptions = false
    @Published var editingEntry: WeatherEntry?
    
    private let userDefaultsKey = "weatherEntries"
    private let categoriesKey = "weatherCategories"
    
    init() {
        loadData()
    }
    
    private func loadData() {
        loadEntries()
        loadCategories()
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedEntries = try? JSONDecoder().decode([WeatherEntry].self, from: data) {
            entries = decodedEntries
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadCategories() {
        if let data = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([WeatherCategory].self, from: data) {
            categories = decodedCategories
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    func addEntry(_ entry: WeatherEntry) {
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: WeatherEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: WeatherEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteEntry(at indexSet: IndexSet) {
        let filteredEntries = filteredAndSortedEntries
        for index in indexSet {
            if let entryToDelete = filteredEntries[safe: index] {
                deleteEntry(entryToDelete)
            }
        }
    }
    
    func addCategory(_ category: WeatherCategory) {
        categories.append(category)
        saveCategories()
    }
    
    func deleteCategory(_ category: WeatherCategory) {
        let entriesUsingCategory = entries.filter { $0.category.id == category.id }
        if entriesUsingCategory.isEmpty {
            categories.removeAll { $0.id == category.id }
            saveCategories()
        }
    }
    
    func categoryEntryCount(_ category: WeatherCategory) -> Int {
        return entries.filter { $0.category.id == category.id }.count
    }
    
    var filteredAndSortedEntries: [WeatherEntry] {
        var result = entries
        
        if let selectedCategory = filterState.selectedCategory {
            result = result.filter { $0.category.id == selectedCategory.id }
        }
        
        switch filterState.sortOption {
        case .dateDescending:
            result.sort { $0.date > $1.date }
        case .dateAscending:
            result.sort { $0.date < $1.date }
        case .alphabetical:
            result.sort { $0.description.localizedCaseInsensitiveCompare($1.description) == .orderedAscending }
        }
        
        return result
    }
    
    func applyFilter(category: WeatherCategory?) {
        filterState.selectedCategory = category
    }
    
    func clearFilter() {
        filterState.selectedCategory = nil
    }
    
    func applySorting(_ option: SortOption) {
        filterState.sortOption = option
    }
    
    func startEditingEntry(_ entry: WeatherEntry) {
        editingEntry = entry
        isShowingCreateEntry = true
    }
    
    func stopEditingEntry() {
        editingEntry = nil
        isShowingCreateEntry = false
    }
    
    var totalEntriesCount: Int {
        return entries.count
    }
    
    var filteredEntriesCount: Int {
        return filteredAndSortedEntries.count
    }
    
    var hasEntries: Bool {
        return !entries.isEmpty
    }
    
    var hasFilteredResults: Bool {
        return !filteredAndSortedEntries.isEmpty
    }
}

class CreateEntryViewModel: ObservableObject {
    @Published var description: String = ""
    @Published var selectedCategory: WeatherCategory = WeatherCategory.sunny
    @Published var selectedDate: Date = Date()
    @Published var isShowingNewCategoryAlert = false
    @Published var newCategoryName = ""
    
    let weatherEntriesViewModel: WeatherEntriesViewModel
    private let editingEntry: WeatherEntry?
    
    init(weatherEntriesViewModel: WeatherEntriesViewModel, editingEntry: WeatherEntry? = nil) {
        self.weatherEntriesViewModel = weatherEntriesViewModel
        self.editingEntry = editingEntry
        
        if let entry = editingEntry {
            self.description = entry.description
            self.selectedCategory = entry.category
            self.selectedDate = entry.date
        }
    }
    
    var isEditing: Bool {
        return editingEntry != nil
    }
    
    var canSave: Bool {
        return !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var navigationTitle: String {
        return isEditing ? "Edit Entry" : "New Entry"
    }
    
    func save() {
        guard canSave else { return }
        
        if let existingEntry = editingEntry {
            var updatedEntry = existingEntry
            updatedEntry.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedEntry.category = selectedCategory
            updatedEntry.date = selectedDate
            weatherEntriesViewModel.updateEntry(updatedEntry)
        } else {
            let newEntry = WeatherEntry(
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                date: selectedDate
            )
            weatherEntriesViewModel.addEntry(newEntry)
        }
        
        weatherEntriesViewModel.stopEditingEntry()
    }
    
    func createNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newCategory = WeatherCategory(name: trimmedName)
        weatherEntriesViewModel.addCategory(newCategory)
        selectedCategory = newCategory
        newCategoryName = ""
        isShowingNewCategoryAlert = false
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
