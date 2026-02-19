import Foundation
import SwiftUI
import Combine

class StoreViewModel: ObservableObject {
    @Published var stores: [Store] = []
    @Published var filteredStores: [Store] = []
    @Published var searchText: String = ""
    @Published var selectedCategories: Set<StoreCategory> = []
    @Published var selectedTypes: Set<StoreType> = []
    @Published var selectedPriceLevels: Set<PriceLevel> = []
    @Published var isFiltering: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let storesKey = "SavedStores"
    
    init() {
        loadStores()
        updateFilteredStores()
    }
    
    func addStore(_ store: Store) {
        stores.append(store)
        saveStores()
        updateFilteredStores()
    }
    
    func updateStore(_ store: Store) {
        if let index = stores.firstIndex(where: { $0.id == store.id }) {
            stores[index] = store
            saveStores()
            updateFilteredStores()
        }
    }
    
    func deleteStore(_ store: Store) {
        stores.removeAll { $0.id == store.id }
        saveStores()
        updateFilteredStores()
    }
    
    func searchStores() {
        updateFilteredStores()
    }
    
    func applyFilters() {
        isFiltering = !selectedCategories.isEmpty || !selectedTypes.isEmpty || !selectedPriceLevels.isEmpty
        updateFilteredStores()
    }
    
    func clearFilters() {
        selectedCategories.removeAll()
        selectedTypes.removeAll()
        selectedPriceLevels.removeAll()
        isFiltering = false
        updateFilteredStores()
    }
    
    func getStoresByCategory(_ category: StoreCategory) -> [Store] {
        return stores.filter { $0.category == category }
    }
    
    func getCategoryCounts() -> [StoreCategory: Int] {
        var counts: [StoreCategory: Int] = [:]
        for category in StoreCategory.allCases {
            counts[category] = stores.filter { $0.category == category }.count
        }
        return counts
    }
    
    func updateFilteredStores() {
        var result = stores
        
        if !searchText.isEmpty {
            result = result.filter { store in
                store.name.localizedCaseInsensitiveContains(searchText) ||
                store.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !selectedCategories.isEmpty {
            result = result.filter { selectedCategories.contains($0.category) }
        }
        
        if !selectedTypes.isEmpty {
            result = result.filter { selectedTypes.contains($0.type) }
        }
        
        if !selectedPriceLevels.isEmpty {
            result = result.filter { selectedPriceLevels.contains($0.priceLevel) }
        }
        
        filteredStores = result
    }
    
    private func saveStores() {
        if let encoded = try? JSONEncoder().encode(stores) {
            userDefaults.set(encoded, forKey: storesKey)
        }
    }
    
    private func loadStores() {
        if let data = userDefaults.data(forKey: storesKey),
           let decoded = try? JSONDecoder().decode([Store].self, from: data) {
            stores = decoded
        }
    }
}
