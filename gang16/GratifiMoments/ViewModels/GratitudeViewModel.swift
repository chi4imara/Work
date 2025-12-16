import Foundation
import SwiftUI
import Combine

class GratitudeViewModel: ObservableObject {
    @Published var entries: [GratitudeEntry] = []
    @Published var searchText: String = ""
    @Published var selectedDateRange: ClosedRange<Date>?
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "GratitudeEntries"
    
    init() {
        loadEntries()
    }
    
    func saveEntry(_ text: String) {
        let today = DateFormatter.dayFormatter.string(from: Date())
        
        if hasEntryForToday() {
            return
        }
        
        let newEntry = GratitudeEntry(text: text, date: today)
        entries.append(newEntry)
        saveEntries()
    }
    
    func updateEntry(_ entry: GratitudeEntry, with newText: String) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].updateText(newText)
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: GratitudeEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteAllEntries() {
        entries.removeAll()
        saveEntries()
    }
    
    func getTodaysEntry() -> GratitudeEntry? {
        let today = DateFormatter.dayFormatter.string(from: Date())
        return entries.first { $0.date == today }
    }
    
    func hasEntryForToday() -> Bool {
        return getTodaysEntry() != nil
    }
    
    func getRandomEntry() -> GratitudeEntry? {
        guard !entries.isEmpty else { return nil }
        return entries.randomElement()
    }
    
    func getFilteredEntries() -> [GratitudeEntry] {
        var filtered = entries
        
        if !searchText.isEmpty {
            filtered = filtered.filter { entry in
                entry.text.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let dateRange = selectedDateRange {
            let formatter = DateFormatter.dayFormatter
            filtered = filtered.filter { entry in
                if let entryDate = formatter.date(from: entry.date) {
                    return dateRange.contains(entryDate)
                }
                return false
            }
        }
        
        return filtered.sorted { entry1, entry2 in
            let formatter = DateFormatter.dayFormatter
            let date1 = formatter.date(from: entry1.date) ?? Date.distantPast
            let date2 = formatter.date(from: entry2.date) ?? Date.distantPast
            return date1 > date2
        }
    }
    
    var entriesCount: Int {
        return entries.count
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([GratitudeEntry].self, from: data) {
            entries = decoded
        }
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func clearDateFilter() {
        selectedDateRange = nil
    }
    
    func setDateRange(_ range: ClosedRange<Date>) {
        selectedDateRange = range
    }
}
