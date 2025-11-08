import Foundation
import SwiftUI
import Combine

class EmotionDataManager: ObservableObject {
    @Published var entries: [EmotionEntry] = []
    @Published var archivedEntries: [EmotionEntry] = []
    @Published var filteredEntries: [EmotionEntry] = []
    @Published var isFiltered = false
    @Published var isViewingArchive = false
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "EmotionEntries"
    private let archivedKey = "ArchivedEntries"
    
    init() {
        loadEntries()
        loadArchivedEntries()
        filteredEntries = entries
    }
    
    func addEntry(_ entry: EmotionEntry) {
        entries.append(entry)
        sortEntries()
        saveEntries()
        updateFilteredEntries()
    }
    
    func updateEntry(_ entry: EmotionEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            sortEntries()
            saveEntries()
            updateFilteredEntries()
        }
    }
    
    func archiveEntry(_ entry: EmotionEntry) {
        entries.removeAll { $0.id == entry.id }
        archivedEntries.append(entry)
        sortArchivedEntries()
        saveEntries()
        saveArchivedEntries()
        updateFilteredEntries()
    }
    
    func deleteFromArchive(_ entry: EmotionEntry) {
        archivedEntries.removeAll { $0.id == entry.id }
        saveArchivedEntries()
        
        if isViewingArchive {
            if isFiltered {
                applyFilters(dateFrom: nil, dateTo: nil, emotions: [], useArchived: true)
            } else {
                filteredEntries = archivedEntries
            }
        } else {
            updateFilteredEntries()
        }
    }
    
    func deleteEntry(_ entry: EmotionEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
        updateFilteredEntries()
    }
    
    func applyFilters(dateFrom: Date?, dateTo: Date?, emotions: Set<EmotionType>, useArchived: Bool = false) {
        isViewingArchive = useArchived
        var filtered = useArchived ? archivedEntries : entries
        
        if let from = dateFrom {
            filtered = filtered.filter { $0.date >= from }
        }
        
        if let to = dateTo {
            let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: to) ?? to
            filtered = filtered.filter { $0.date <= endOfDay }
        }
        
        if !emotions.isEmpty {
            filtered = filtered.filter { emotions.contains($0.emotion) }
        }
        
        filteredEntries = filtered
        isFiltered = dateFrom != nil || dateTo != nil || !emotions.isEmpty
    }
    
    func clearFilters(useArchived: Bool = false) {
        isViewingArchive = useArchived
        filteredEntries = useArchived ? archivedEntries : entries
        isFiltered = false
    }
    
    private func updateFilteredEntries() {
        if !isFiltered {
            filteredEntries = isViewingArchive ? archivedEntries : entries
        }
    }
    
    private func sortEntries() {
        entries.sort { $0.date > $1.date }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([EmotionEntry].self, from: data) {
            entries = decoded
            sortEntries()
        }
    }
    
    private func loadArchivedEntries() {
        if let data = userDefaults.data(forKey: archivedKey),
           let decoded = try? JSONDecoder().decode([EmotionEntry].self, from: data) {
            archivedEntries = decoded
            sortArchivedEntries()
        }
    }
    
    private func saveArchivedEntries() {
        if let encoded = try? JSONEncoder().encode(archivedEntries) {
            userDefaults.set(encoded, forKey: archivedKey)
        }
    }
    
    private func sortArchivedEntries() {
        archivedEntries.sort { $0.date > $1.date }
    }
}
