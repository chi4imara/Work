import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var entries: [MoodEntry] = []
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "mood_entries"
    
    private init() {
        loadEntries()
    }
    
    func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            self.entries = decodedEntries.sorted { $0.date > $1.date }
        }
    }
    
    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    func addEntry(_ entry: MoodEntry) {
        entries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: entry.date) }
        
        entries.append(entry)
        entries.sort { $0.date > $1.date }
        
        saveEntries()
    }
    
    func updateEntry(_ entry: MoodEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            entries.sort { $0.date > $1.date }
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: MoodEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func getEntry(for date: Date) -> MoodEntry? {
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getTodayEntry() -> MoodEntry? {
        return getEntry(for: Date())
    }
    
    func getEntriesForPeriod(_ period: StatisticsPeriod) -> [MoodEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            return entries.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return entries.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return entries.filter { $0.date >= yearAgo }
        }
    }
    
    func getEntriesForMonth(_ date: Date) -> [MoodEntry] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start ?? date
        let endOfMonth = calendar.dateInterval(of: .month, for: date)?.end ?? date
        
        return entries.filter { entry in
            entry.date >= startOfMonth && entry.date < endOfMonth
        }
    }
}

enum StatisticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
