import Foundation
import SwiftUI
import Combine

class InventoryViewModel: ObservableObject {
    @Published var items: [InventoryItem] = []
    @Published var filteredItems: [InventoryItem] = []
    @Published var selectedFilter: FilterType = .all
    @Published var selectedCategory: ItemCategory?
    @Published var selectedStatus: ItemStatus?
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case category = "Categories"
        case status = "By Status"
        
        var displayName: String { rawValue }
    }
    
    init() {
        loadItems()
        updateFilteredItems()
    }
    
    func addItem(_ item: InventoryItem) {
        items.append(item)
        saveItems()
        updateFilteredItems()
    }
    
    func updateItem(_ updatedItem: InventoryItem) {
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            var item = updatedItem
            item.updateModifiedDate()
            items[index] = item
            saveItems()
            updateFilteredItems()
        }
    }
    
    func deleteItem(_ item: InventoryItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
        updateFilteredItems()
    }
    
    func applyFilter(_ filter: FilterType, category: ItemCategory? = nil, status: ItemStatus? = nil) {
        selectedFilter = filter
        selectedCategory = category
        selectedStatus = status
        updateFilteredItems()
    }
    
    private func updateFilteredItems() {
        switch selectedFilter {
        case .all:
            filteredItems = items
        case .category:
            if let category = selectedCategory {
                filteredItems = items.filter { $0.category == category }
            } else {
                filteredItems = items
            }
        case .status:
            if let status = selectedStatus {
                filteredItems = items.filter { $0.status == status }
            } else {
                filteredItems = items
            }
        }
    }
    
    func getCategoryStats() -> [CategoryStats] {
        let categories = ItemCategory.allCases
        return categories.map { category in
            let count = items.filter { $0.category == category }.count
            return CategoryStats(category: category, count: count)
        }.filter { $0.count > 0 }
    }
    
    func getStatusStats() -> [StatusStats] {
        let statuses = ItemStatus.allCases
        return statuses.map { status in
            let count = items.filter { $0.status == status }.count
            return StatusStats(status: status, count: count)
        }.filter { $0.count > 0 }
    }
    
    func getItem(by id: UUID) -> InventoryItem? {
        return items.first { $0.id == id }
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "InventoryItems")
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "InventoryItems"),
           let decoded = try? JSONDecoder().decode([InventoryItem].self, from: data) {
            items = decoded
        }
    }
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    init() {
        loadNotes()
    }
    
    func addNote(_ note: Note) {
        notes.insert(note, at: 0)
        saveNotes()
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "Notes")
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "Notes"),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded.sorted { $0.dateCreated > $1.dateCreated }
        }
    }
}

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var showingSplash: Bool = true
    @Published var selectedTab: Int = 0
    
    init() {
        checkFirstLaunch()
    }
    
    func completeSplash() {
        showingSplash = false
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        UserDefaults.standard.set(false, forKey: "IsFirstLaunch")
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
        }
    }
}
