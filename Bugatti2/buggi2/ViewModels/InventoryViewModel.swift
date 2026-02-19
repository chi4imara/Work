import Foundation
import SwiftUI
import Combine

class InventoryViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var searchText = ""
    
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "SavedItems"
    
    init() {
        loadItems()
    }
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.location.localizedCaseInsensitiveContains(searchText) ||
                item.owner.localizedCaseInsensitiveContains(searchText) ||
                item.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
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
    
    func item(byId id: UUID) -> Item? {
        items.first { $0.id == id }
    }
    
    func loadSampleData() {
        items = Item.sampleItems
        saveItems()
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            userDefaults.set(encoded, forKey: itemsKey)
        }
    }
    
    private func loadItems() {
        if let data = userDefaults.data(forKey: itemsKey),
           let decodedItems = try? JSONDecoder().decode([Item].self, from: data) {
            items = decodedItems
        }
    }
}
