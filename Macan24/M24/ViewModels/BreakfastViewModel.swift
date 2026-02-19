import Foundation
import SwiftUI
import Combine

class BreakfastViewModel: ObservableObject {
    @Published var breakfasts: [Breakfast] = []
    @Published var filteredBreakfasts: [Breakfast] = []
    @Published var searchText: String = ""
    @Published var selectedCategories: Set<BreakfastCategory> = []
    @Published var drinkFilter: String = ""
    @Published var isFiltering: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let breakfastsKey = "SavedBreakfasts"
    
    init() {
        loadBreakfasts()
        updateFilteredBreakfasts()
    }
        
    func addBreakfast(_ breakfast: Breakfast) {
        breakfasts.append(breakfast)
        saveBreakfasts()
        updateFilteredBreakfasts()
    }
    
    func updateBreakfast(_ breakfast: Breakfast) {
        if let index = breakfasts.firstIndex(where: { $0.id == breakfast.id }) {
            breakfasts[index] = breakfast
            saveBreakfasts()
            updateFilteredBreakfasts()
        }
    }
    
    func deleteBreakfast(_ breakfast: Breakfast) {
        breakfasts.removeAll { $0.id == breakfast.id }
        saveBreakfasts()
        updateFilteredBreakfasts()
    }
        
    func updateFilteredBreakfasts() {
        var filtered = breakfasts
        
        if !searchText.isEmpty {
            filtered = filtered.filter { breakfast in
                breakfast.name.localizedCaseInsensitiveContains(searchText) ||
                breakfast.category.displayName.localizedCaseInsensitiveContains(searchText) ||
                breakfast.dishes.localizedCaseInsensitiveContains(searchText) ||
                breakfast.drink.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !selectedCategories.isEmpty {
            filtered = filtered.filter { selectedCategories.contains($0.category) }
        }
        
        if !drinkFilter.isEmpty {
            filtered = filtered.filter { $0.drink.localizedCaseInsensitiveContains(drinkFilter) }
        }
        
        filteredBreakfasts = filtered.sorted { $0.dateCreated > $1.dateCreated }
        isFiltering = !searchText.isEmpty || !selectedCategories.isEmpty || !drinkFilter.isEmpty
    }
    
    func filterByCategory(_ category: BreakfastCategory) {
        selectedCategories = [category]
        searchText = ""
        drinkFilter = ""
        updateFilteredBreakfasts()
    }
    
    func clearFilters() {
        selectedCategories.removeAll()
        searchText = ""
        drinkFilter = ""
        updateFilteredBreakfasts()
    }
        
    func getBreakfastCount(for category: BreakfastCategory) -> Int {
        return breakfasts.filter { $0.category == category }.count
    }
    
    func getCategoriesWithCounts() -> [(category: BreakfastCategory, count: Int)] {
        return BreakfastCategory.allCases.map { category in
            (category: category, count: getBreakfastCount(for: category))
        }.filter { $0.count > 0 }
    }
        
    private func saveBreakfasts() {
        if let encoded = try? JSONEncoder().encode(breakfasts) {
            userDefaults.set(encoded, forKey: breakfastsKey)
        }
    }
    
    private func loadBreakfasts() {
        if let data = userDefaults.data(forKey: breakfastsKey),
           let decoded = try? JSONDecoder().decode([Breakfast].self, from: data) {
            breakfasts = decoded
        }
    }
}
