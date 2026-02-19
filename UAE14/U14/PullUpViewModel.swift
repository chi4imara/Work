import Foundation
import SwiftUI
import Combine

class PullUpViewModel: ObservableObject {
    @Published var entries: [PullUpEntry] = []
    @Published var selectedPeriod: TimePeriod = .all
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "pullup_entries"
    
    init() {
        loadEntries()
    }
    
    func addEntry(_ entry: PullUpEntry) {
        entries.append(entry)
        sortEntries()
        saveEntries()
    }
    
    func updateEntry(_ entry: PullUpEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            sortEntries()
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: PullUpEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func clearAllData() {
        entries.removeAll()
        saveEntries()
    }
    
    var filteredEntries: [PullUpEntry] {
        guard let days = selectedPeriod.days else {
            return entries.sorted { $0.date > $1.date }
        }
        
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return entries
            .filter { $0.date >= cutoffDate }
            .sorted { $0.date > $1.date }
    }
    
    var statistics: Statistics {
        return Statistics(entries: filteredEntries)
    }
    
    var overallStatistics: Statistics {
        return Statistics(entries: entries)
    }
    
    var chartData: [(Date, Int)] {
        return filteredEntries
            .sorted { $0.date < $1.date }
            .map { ($0.date, $0.count) }
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
           let decoded = try? JSONDecoder().decode([PullUpEntry].self, from: data) {
            entries = decoded
            sortEntries()
        }
    }
}
