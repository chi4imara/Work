import Foundation
import SwiftUI
import Combine

class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    @Published var searchText: String = ""
    @Published var selectedMoodFilter: MoodType?
    @Published var showingNewEntry = false
    @Published var selectedEntry: DiaryEntry?
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "diary_entries"
    
    init() {
        loadEntries()
    }
    
    var filteredEntries: [DiaryEntry] {
        var filtered = entries
        
        if !searchText.isEmpty {
            filtered = filtered.filter { entry in
                entry.text.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let moodFilter = selectedMoodFilter {
            filtered = filtered.filter { entry in
                entry.mood == moodFilter || entry.emotions.contains(moodFilter)
            }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    var favoriteEntries: [DiaryEntry] {
        return entries.filter { $0.isFavorite }.sorted { $0.date > $1.date }
    }
    
    var recentEntries: [DiaryEntry] {
        return Array(entries.sorted { $0.date > $1.date }.prefix(3))
    }
    
    func entry(byId id: UUID) -> DiaryEntry? {
        entries.first { $0.id == id }
    }
    
    func addEntry(_ entry: DiaryEntry) {
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: DiaryEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: DiaryEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteEntry(byId id: UUID) {
        entries.removeAll { $0.id == id }
        saveEntries()
    }
    
    func toggleFavorite(_ entry: DiaryEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].isFavorite.toggle()
            saveEntries()
        }
    }
    
    func loadSampleData() {
        entries = DiaryEntry.sampleDataForTesting
        saveEntries()
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([DiaryEntry].self, from: data) {
            entries = decoded
        } else {
            saveEntries()
        }
    }
}
