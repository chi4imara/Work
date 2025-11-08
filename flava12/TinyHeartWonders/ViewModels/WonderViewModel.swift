import Foundation
import SwiftUI

class WonderViewModel: ObservableObject {
    @Published var entries: [WonderEntry] = []
    @Published var selectedPeriod: TimePeriod = .all
    @Published var sortOrder: SortOrder = .newest
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var showingAddEntry: Bool = false
    @Published var selectedEntry: WonderEntry?
    
    private let dataManager = DataManager.shared
    
    init() {
        loadEntries()
        
        dataManager.$entries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadEntries()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadEntries() {
        entries = dataManager.getEntries(for: selectedPeriod, sortOrder: sortOrder)
    }
    
    func addEntry(title: String, description: String, date: Date, time: Date) {
        let entry = WonderEntry(title: title, description: description, date: date, time: time)
        dataManager.addEntry(entry)
    }
    
    func updateEntry(_ entry: WonderEntry, title: String, description: String, date: Date, time: Date) {
        var updatedEntry = entry
        updatedEntry.update(title: title, description: description, date: date, time: time)
        dataManager.updateEntry(updatedEntry)
    }
    
    func deleteEntry(_ entry: WonderEntry) {
        dataManager.deleteEntry(entry)
    }
    
    func deleteEntries(at indexSet: IndexSet) {
        dataManager.deleteEntry(at: indexSet)
    }
    
    func setPeriod(_ period: TimePeriod) {
        selectedPeriod = period
        loadEntries()
    }
    
    func setSortOrder(_ order: SortOrder) {
        sortOrder = order
        loadEntries()
    }
    
    func searchEntries(query: String) {
        searchQuery = query
        if query.isEmpty {
            loadEntries()
        } else {
            entries = dataManager.searchEntries(query: query, period: selectedPeriod)
        }
    }
    
    func getStatistics(for period: TimePeriod) -> WonderStatistics {
        return dataManager.getStatistics(for: period)
    }
    
    func showAddEntry() {
        selectedEntry = nil
        showingAddEntry = true
    }
    
    func showEditEntry(_ entry: WonderEntry) {
        selectedEntry = entry
    }
    
    func hideAddEntry() {
        showingAddEntry = false
        selectedEntry = nil
    }
    
    func validateTitle(_ title: String) -> Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func validateTitleLength(_ title: String) -> Bool {
        return title.count <= 50
    }
    
    func validateDescriptionLength(_ description: String) -> Bool {
        return description.count <= 300
    }
}

import Combine
