import Foundation
import SwiftUI
import Combine

class WardrobeViewModel: ObservableObject {
    @Published var items: [WardrobeItem] = []
    @Published var selectedSeason: Season = .spring
    @Published var selectedFilter: ItemFilter = .all
    @Published var isFirstLaunch: Bool = true
    
    init() {
        loadItems()
        checkFirstLaunch()
    }
    
    var filteredItems: [WardrobeItem] {
        let seasonFiltered = items.filter { $0.season == selectedSeason }
        
        switch selectedFilter {
        case .all:
            return seasonFiltered
        case .inUse:
            return seasonFiltered.filter { $0.status == .inUse }
        case .store:
            return seasonFiltered.filter { $0.status == .store }
        case .buy:
            return seasonFiltered.filter { $0.status == .buy }
        }
    }
    
    var shoppingItems: [WardrobeItem] {
        return items.filter { $0.status == .buy }
    }
    
    func addItem(_ item: WardrobeItem) {
        items.append(item)
        saveItems()
    }
    
    func updateItem(_ item: WardrobeItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems()
        }
    }
    
    func deleteItem(_ item: WardrobeItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func updateItemStatus(_ item: WardrobeItem, newStatus: ItemStatus) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].status = newStatus
            saveItems()
        }
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "wardrobe_items")
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "wardrobe_items"),
           let decoded = try? JSONDecoder().decode([WardrobeItem].self, from: data) {
            items = decoded
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "has_launched_before")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "has_launched_before")
        }
    }
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    
    init() {
        loadNotes()
    }
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes.sorted { $0.dateCreated > $1.dateCreated }
        } else {
            return notes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.dateCreated > $1.dateCreated }
        }
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }
}

class AppStateViewModel: ObservableObject {
    @Published var isShowingSplash: Bool = true
    @Published var hasCompletedOnboarding: Bool = false
    @Published var selectedTab: Int = 0
    
    init() {
        checkOnboardingStatus()
    }
    
    private func checkOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "has_completed_onboarding")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        UserDefaults.standard.set(false, forKey: "has_completed_onboarding")
    }
}
