import Foundation
import Combine

class DiaryManager: ObservableObject {
    static let shared = DiaryManager()
    
    @Published var entries: [DiaryEntry] = []
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "diary_entries"
    
    private init() {
        loadEntries()
    }
        
    func addEntry(_ text: String) {
        let entry = DiaryEntry(text: text)
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: DiaryEntry, with text: String) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].updateText(text)
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: DiaryEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteAllEntries() {
        entries.removeAll()
        saveEntries()
    }
        
    func getTodayEntry() -> DiaryEntry? {
        let today = DateManager.shared.todayString()
        return entries.first { $0.date == today }
    }
    
    func getRandomEntry() -> DiaryEntry? {
        guard !entries.isEmpty else { return nil }
        return entries.randomElement()
    }
    
    func getRandomEntry(excluding current: DiaryEntry?) -> DiaryEntry? {
        let availableEntries = entries.filter { $0.id != current?.id }
        return availableEntries.randomElement()
    }
    
    func searchEntries(query: String) -> [DiaryEntry] {
        guard !query.isEmpty else { return sortedEntries }
        return entries.filter { $0.text.localizedCaseInsensitiveContains(query) }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func filterEntries(from startDate: Date, to endDate: Date) -> [DiaryEntry] {
        return entries.filter { entry in
            guard let entryDate = DateManager.shared.dateFromString(entry.date) else { return false }
            return entryDate >= startDate && entryDate <= endDate
        }.sorted { $0.createdAt > $1.createdAt }
    }
    
    var sortedEntries: [DiaryEntry] {
        return entries.sorted { $0.createdAt > $1.createdAt }
    }
    
    var entriesCount: Int {
        return entries.count
    }
    
    var hasEntries: Bool {
        return !entries.isEmpty
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
        }
    }
}
