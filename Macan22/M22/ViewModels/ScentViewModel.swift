import Foundation
import SwiftUI
import Combine

@MainActor
class ScentViewModel: ObservableObject {
    @Published var scents: [Scent] = []
    @Published var filteredScents: [Scent] = []
    @Published var filter = ScentFilter()
    @Published var selectedCategory: Season? = nil
    
    private let userDefaults = UserDefaults.standard
    private let scentsKey = "SavedScents"
    
    init() {
        loadScents()
        applyFilters()
    }
    
    func saveScents() {
        if let encoded = try? JSONEncoder().encode(scents) {
            userDefaults.set(encoded, forKey: scentsKey)
        }
    }
    
    func loadScents() {
        if let data = userDefaults.data(forKey: scentsKey),
           let decoded = try? JSONDecoder().decode([Scent].self, from: data) {
            scents = decoded
        }
    }
    
    func addScent(_ scent: Scent) {
        scents.append(scent)
        saveScents()
        applyFilters()
    }
    
    func updateScent(_ scent: Scent) {
        if let index = scents.firstIndex(where: { $0.id == scent.id }) {
            scents[index] = scent
            saveScents()
            applyFilters()
        }
    }
    
    func deleteScent(_ scent: Scent) {
        scents.removeAll { $0.id == scent.id }
        saveScents()
        applyFilters()
    }
    
    func deleteScent(at indexSet: IndexSet) {
        scents.remove(atOffsets: indexSet)
        saveScents()
        applyFilters()
    }
    
    func applyFilters() {
        var result = scents
        
        if let selectedCategory = selectedCategory {
            result = result.filter { $0.season == selectedCategory }
        }
        
        if filter.isActive {
            result = result.filter { filter.matches($0) }
        }
        
        filteredScents = result.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func setFilter(_ newFilter: ScentFilter) {
        filter = newFilter
        applyFilters()
    }
    
    func clearFilters() {
        filter = ScentFilter()
        selectedCategory = nil
        applyFilters()
    }
    
    func setCategory(_ season: Season?) {
        selectedCategory = season
        applyFilters()
    }
    
    func updateSearchText(_ text: String) {
        filter.searchText = text
        applyFilters()
    }
    
    func getCategories() -> [ScentCategory] {
        let categoryCounts = Dictionary(grouping: scents, by: { $0.season })
            .mapValues { $0.count }
        
        return Season.allCases.compactMap { season in
            let count = categoryCounts[season] ?? 0
            return count > 0 ? ScentCategory(season: season, count: count) : nil
        }
    }
    
    var isEmpty: Bool {
        return scents.isEmpty
    }
    
    var hasFilteredResults: Bool {
        return !filteredScents.isEmpty
    }
    
    var isFiltered: Bool {
        return filter.isActive || selectedCategory != nil
    }
}
