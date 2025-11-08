import Foundation
import SwiftUI
import Combine

class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var categories: [Category] = []
    @Published var filteredPlaces: [Place] = []
    @Published var selectedCategory: String = "All"
    @Published var showOnlyFavorites: Bool = false
    @Published var sortByDate: Bool = true 
    
    private let placesKey = "SavedPlaces"
    private let categoriesKey = "SavedCategories"
    
    init() {
        loadData()
        updateFilteredPlaces()
    }
    
    func addPlace(_ place: Place) {
        places.append(place)
        if !categories.contains { $0.name == place.category } {
            let category = place.category
            categories.append(Category(name: category))
        } else {
            if let existingCategory = categories.first(where: { $0.name == place.category }) {
                for i in (0..<categories.count) {
                    if categories[i] == existingCategory {
                        categories[i].placesCount += 1
                    }
                }
            }
        }
        updateCategoryInfo()
        saveData()
        updateFilteredPlaces()
    }
    
    func updatePlace(_ updatedPlace: Place) {
        if let index = places.firstIndex(where: { $0.id == updatedPlace.id }) {
            places[index] = updatedPlace
            updateCategoryInfo()
            saveData()
            updateFilteredPlaces()
        }
    }
    
    func deletePlace(_ place: Place) {
        places.removeAll { $0.id == place.id }
        updateCategoryInfo()
        saveData()
        updateFilteredPlaces()
    }
    
    func toggleFavorite(for place: Place) {
        if let index = places.firstIndex(where: { $0.id == place.id }) {
            places[index].isFavorite.toggle()
            saveData()
            updateFilteredPlaces()
        }
    }
    
    func addCategory(_ categoryName: String) {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Attempting to add category: '\(trimmedName)'")
        
        guard !trimmedName.isEmpty else {
            print("Category name is empty")
            return
        }
        
        guard !categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            print("Category '\(trimmedName)' already exists")
            return
        }
        
        let category = Category(name: trimmedName)
        categories.append(category)
        print("Category '\(trimmedName)' added successfully. Total categories: \(categories.count)")
        updateCategoryInfo()
        saveData()
        updateFilteredPlaces()
    }
    
    func updateCategory(oldName: String, newName: String) {
        let trimmedNewName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNewName.isEmpty,
              !categories.contains(where: { $0.name.lowercased() == trimmedNewName.lowercased() && $0.name != oldName }) else {
            return
        }
        
        if let categoryIndex = categories.firstIndex(where: { $0.name == oldName }) {
            categories[categoryIndex].name = trimmedNewName
        }
        
        for index in places.indices {
            if places[index].category == oldName {
                places[index].category = trimmedNewName
            }
        }
        
        saveData()
        updateFilteredPlaces()
    }
    
    func deleteCategory(_ categoryName: String) {
        let placesInCategory = places.filter { $0.category == categoryName }
        guard placesInCategory.isEmpty else { return }
        
        categories.removeAll { $0.name == categoryName }
        saveData()
    }
    
    func canDeleteCategory(_ categoryName: String) -> Bool {
        return places.filter { $0.category == categoryName }.isEmpty
    }
    
    func updateFilteredPlaces() {
        var filtered = places
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if showOnlyFavorites {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        if sortByDate {
            filtered.sort { $0.dateAdded > $1.dateAdded }
        } else {
            filtered.sort { $0.name.lowercased() < $1.name.lowercased() }
        }
        
        filteredPlaces = filtered
    }
    
    func resetFilters() {
        selectedCategory = "All"
        showOnlyFavorites = false
        updateFilteredPlaces()
    }
    
    var favoriteePlaces: [Place] {
        places.filter { $0.isFavorite }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var categoryNames: [String] {
        let names = categories.map { $0.name }.sorted()
        print("categoryNames: \(names)")
        return names
    }
    
    var totalPlaces: Int {
        places.count
    }
    
    var totalCategories: Int {
        categories.count
    }
    
    var totalFavorites: Int {
        places.filter { $0.isFavorite }.count
    }
    
    var placesAddedThisWeek: Int {
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
        return places.filter { $0.dateAdded >= oneWeekAgo }.count
    }
    
    var placesAddedThisMonth: Int {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return places.filter { $0.dateAdded >= oneMonthAgo }.count
    }
    
    var mostPopularCategory: String {
        let categoryCounts = Dictionary(grouping: places, by: { $0.category })
            .mapValues { $0.count }
        
        return categoryCounts.max(by: { $0.value < $1.value })?.key ?? "No categories"
    }
    
    var categoryStatistics: [(String, Int)] {
        let categoryCounts = Dictionary(grouping: places, by: { $0.category })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
        
        return categoryCounts.map { ($0.key, $0.value) }
    }
    
    var recentPlaces: [Place] {
        places.sorted { $0.dateAdded > $1.dateAdded }.prefix(5).map { $0 }
    }
    
    var averagePlacesPerCategory: Double {
        guard !categories.isEmpty else { return 0 }
        return Double(places.count) / Double(categories.count)
    }
    
    private func updateCategoryInfo() {
        print("updateCategoryInfo called. Categories before: \(categories.count)")
        
        for index in categories.indices {
            let categoryName = categories[index].name
            let placesInCategory = places.filter { $0.category == categoryName }
            categories[index].placesCount = placesInCategory.count
            categories[index].lastAddedPlace = placesInCategory.sorted { $0.dateAdded > $1.dateAdded }.first?.name ?? ""
        }
        
        let existingCategoryNames = Set(categories.map { $0.name })
        let placeCategoryNames = Set(places.map { $0.category })
        let newCategoryNames = placeCategoryNames.subtracting(existingCategoryNames)
        
        for categoryName in newCategoryNames {
            let category = Category(name: categoryName)
            categories.append(category)
        }
        
        categories.sort { $0.name.lowercased() < $1.name.lowercased() }
        
        print("updateCategoryInfo completed. Categories after: \(categories.count)")
    }
    
    private func saveData() {
        if let placesData = try? JSONEncoder().encode(places) {
            UserDefaults.standard.set(placesData, forKey: placesKey)
        }
        
        if let categoriesData = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(categoriesData, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        if let placesData = UserDefaults.standard.data(forKey: placesKey),
           let decodedPlaces = try? JSONDecoder().decode([Place].self, from: placesData) {
            places = decodedPlaces
        }
        
        if let categoriesData = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories = decodedCategories
        }
        
        updateCategoryInfo()
    }
}
