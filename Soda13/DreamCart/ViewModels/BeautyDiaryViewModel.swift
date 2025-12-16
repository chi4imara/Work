import Foundation
import SwiftUI
import Combine

class BeautyDiaryViewModel: ObservableObject {
    @Published var entries: [BeautyEntry] = []
    @Published var selectedDate = Date()
    @Published var showingOnboarding = true
    @Published var showingSplash = true
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "BeautyEntries"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadEntries()
        checkOnboardingStatus()
    }
        
    func addEntry(_ entry: BeautyEntry) {
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: BeautyEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: BeautyEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteEntry(at indexSet: IndexSet) {
        let filteredEntries = entriesForSelectedDate
        for index in indexSet {
            if let entryToDelete = filteredEntries[safe: index] {
                deleteEntry(entryToDelete)
            }
        }
    }
        
    var entriesForSelectedDate: [BeautyEntry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.date > $1.date }
    }
    
    var allNotes: [String] {
        return entries.compactMap { entry in
            entry.hasNotes ? "\(entry.procedureName) — \(entry.notes)" : nil
        }
    }
    
    var hasEntriesForSelectedDate: Bool {
        !entriesForSelectedDate.isEmpty
    }
        
    func selectDate(_ date: Date) {
        selectedDate = date
    }
        
    func completeOnboarding() {
        showingOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func hideSplash() {
        showingSplash = false
    }
    
    private func checkOnboardingStatus() {
        showingOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
        
    func clearAllNotes() {
        for i in entries.indices {
            entries[i].notes = ""
        }
        saveEntries()
    }
    
    func getEntry(by id: UUID) -> BeautyEntry? {
        return entries.first { $0.id == id }
    }
    
    func toggleFavorite(for entry: BeautyEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].isFavorite.toggle()
            saveEntries()
        }
    }
    
    var favoriteEntries: [BeautyEntry] {
        return entries.filter { $0.isFavorite }
            .sorted { $0.date > $1.date }
    }
    
    var hasFavoriteEntries: Bool {
        !favoriteEntries.isEmpty
    }
    
    func entriesForMonth(_ date: Date) -> [BeautyEntry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDate($0.date, equalTo: date, toGranularity: .month) }
            .sorted { $0.date > $1.date }
    }
    
    func entriesForDate(_ date: Date) -> [BeautyEntry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date > $1.date }
    }
    
    func hasEntriesForDate(_ date: Date) -> Bool {
        !entriesForDate(date).isEmpty
    }
        
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([BeautyEntry].self, from: data) {
            entries = decoded
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
