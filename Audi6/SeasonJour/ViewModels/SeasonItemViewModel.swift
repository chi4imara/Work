import Foundation
import SwiftUI
import Combine

class SeasonItemViewModel: ObservableObject {
    @Published var items: [SeasonItem] = []
    
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "SeasonItems"
    
    init() {
        loadItems()
    }
    
    func addItem(_ item: SeasonItem) {
        items.append(item)
        saveItems()
    }
    
    func updateItem(_ item: SeasonItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems()
        }
    }
    
    func deleteItem(_ item: SeasonItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func deleteItem(byId id: UUID) {
        items.removeAll { $0.id == id }
        saveItems()
    }
    
    func getItem(byId id: UUID) -> SeasonItem? {
        return items.first { $0.id == id }
    }
        
    func itemsForSeason(_ season: Season) -> [SeasonItem] {
        return items.filter { $0.season == season }
    }
    
    var favoriteItems: [SeasonItem] {
        return items.filter { $0.isFavorite }
    }
        
    var totalItemsCount: Int {
        return items.count
    }
    
    func itemsCountForSeason(_ season: Season) -> Int {
        return itemsForSeason(season).count
    }
        
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            userDefaults.set(encoded, forKey: itemsKey)
        }
    }
    
    private func loadItems() {
        if let data = userDefaults.data(forKey: itemsKey),
           let decoded = try? JSONDecoder().decode([SeasonItem].self, from: data) {
            items = decoded
        }
    }
}
