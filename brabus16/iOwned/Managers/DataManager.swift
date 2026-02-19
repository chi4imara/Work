import Foundation
import Combine
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var items: [Item] = []
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "SavedItems"
    
    private init() {
        loadItems()
    }
        
    func addItem(_ item: Item) {
        items.append(item)
        saveItems()
    }
    
    func updateItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems()
        }
    }
    
    func deleteItem(_ item: Item) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func deleteItem(at indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
        saveItems()
    }
        
    func searchItems(query: String) -> [Item] {
        guard !query.isEmpty else { return items }
        
        return items.filter { item in
            item.name.localizedCaseInsensitiveContains(query) ||
            item.characteristics.localizedCaseInsensitiveContains(query) ||
            item.notes.localizedCaseInsensitiveContains(query) ||
            item.category.displayName.localizedCaseInsensitiveContains(query)
        }
    }
        
    private func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            userDefaults.set(data, forKey: itemsKey)
        } catch {
            print("Failed to save items: \(error)")
        }
    }
    
    private func loadItems() {
        guard let data = userDefaults.data(forKey: itemsKey) else { return }
        
        do {
            items = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            print("Failed to load items: \(error)")
        }
    }
}
