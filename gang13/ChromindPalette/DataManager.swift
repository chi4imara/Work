import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var dayEntries: [DayEntry] = []
    @Published var notes: [Note] = []
    @Published var hasCompletedOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let dayEntriesKey = "dayEntries"
    private let notesKey = "notes"
    private let onboardingKey = "hasCompletedOnboarding"
    
    private init() {
        loadData()
    }
    
    private func loadData() {
        loadDayEntries()
        loadNotes()
        loadOnboardingStatus()
    }
    
    private func loadDayEntries() {
        if let data = userDefaults.data(forKey: dayEntriesKey),
           let entries = try? JSONDecoder().decode([DayEntry].self, from: data) {
            self.dayEntries = entries.sorted { $0.date > $1.date }
        }
    }
    
    private func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let notes = try? JSONDecoder().decode([Note].self, from: data) {
            self.notes = notes.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    private func loadOnboardingStatus() {
        self.hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
    }
    
    private func saveDayEntries() {
        if let data = try? JSONEncoder().encode(dayEntries) {
            userDefaults.set(data, forKey: dayEntriesKey)
        }
    }
    
    private func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            userDefaults.set(data, forKey: notesKey)
        }
    }
    
    private func saveOnboardingStatus() {
        userDefaults.set(hasCompletedOnboarding, forKey: onboardingKey)
    }
    
    func addDayEntry(_ entry: DayEntry) {
        dayEntries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: entry.date) }
        
        dayEntries.append(entry)
        dayEntries.sort { $0.date > $1.date }
        saveDayEntries()
    }
    
    func updateDayEntry(_ entry: DayEntry) {
        if let index = dayEntries.firstIndex(where: { $0.id == entry.id }) {
            dayEntries[index] = entry
            saveDayEntries()
        }
    }
    
    func deleteDayEntry(_ entry: DayEntry) {
        dayEntries.removeAll { $0.id == entry.id }
        saveDayEntries()
    }
    
    func getDayEntry(for date: Date) -> DayEntry? {
        return dayEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getTodayEntry() -> DayEntry? {
        return getDayEntry(for: Date())
    }
    
    func addNote(_ note: Note) {
        notes.insert(note, at: 0)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            notes.sort { $0.updatedAt > $1.updatedAt }
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func getStatistics() -> Statistics {
        return Statistics(entries: dayEntries)
    }
    
    func getFilteredEntries(with options: FilterOptions) -> [DayEntry] {
        var filteredEntries = dayEntries
        
        let calendar = Calendar.current
        let now = Date()
        
        switch options.period {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            filteredEntries = filteredEntries.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            filteredEntries = filteredEntries.filter { $0.date >= monthAgo }
        case .all:
            break
        }
        
        if !options.selectedColors.isEmpty {
            filteredEntries = filteredEntries.filter { options.selectedColors.contains($0.color.name) }
        }
        
        if !options.searchText.isEmpty {
            filteredEntries = filteredEntries.filter { 
                $0.description.localizedCaseInsensitiveContains(options.searchText)
            }
        }
        
        return filteredEntries
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveOnboardingStatus()
    }
    
    func canEditToday() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        return hour < 24 
    }
    
    func isNewDay() -> Bool {
        guard let lastEntry = dayEntries.first else { return true }
        return !Calendar.current.isDateInToday(lastEntry.date)
    }
}
