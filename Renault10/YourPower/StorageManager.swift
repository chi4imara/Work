import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let defaults = UserDefaults.standard
    private let habitsKey = "habits"
    private let todayEntryKey = "todayEntry"
    private let dailyEntriesKey = "dailyEntries"
    
    private init() {}
        
    func loadHabits() -> [Habit] {
        if let data = defaults.data(forKey: habitsKey),
           let habits = try? JSONDecoder().decode([Habit].self, from: data) {
            return habits
        }
        let defaultsList = defaultHabits()
        saveHabits(defaultsList)
        return defaultsList
    }
    
    func saveHabits(_ habits: [Habit]) {
        guard let data = try? JSONEncoder().encode(habits) else { return }
        defaults.set(data, forKey: habitsKey)
    }
    
    private func defaultHabits() -> [Habit] {
        [
            Habit(name: "Morning Affirmation", category: .morningRituals, frequency: .daily, icon: "heart.fill"),
            Habit(name: "Gratitude Journal", category: .achievementDiary, frequency: .daily, icon: "book.fill"),
            Habit(name: "Deep Breathing", category: .breathing, frequency: .daily, icon: "lungs.fill")
        ]
    }
        
    func loadTodayEntry() -> DailyEntry? {
        guard let data = defaults.data(forKey: todayEntryKey),
              let entry = try? JSONDecoder().decode(DailyEntry.self, from: data),
              Calendar.current.isDateInToday(entry.date) else {
            return nil
        }
        return entry
    }
    
    func saveTodayEntry(_ entry: DailyEntry) {
        guard let data = try? JSONEncoder().encode(entry) else { return }
        defaults.set(data, forKey: todayEntryKey)
        mergeTodayIntoHistory(entry)
    }
    
    private func mergeTodayIntoHistory(_ today: DailyEntry) {
        var entries = loadDailyEntries()
        if let idx = entries.firstIndex(where: { Calendar.current.isDateInToday($0.date) }) {
            entries[idx] = today
        } else {
            entries.append(today)
        }
        saveDailyEntries(entries)
    }
        
    func loadDailyEntries() -> [DailyEntry] {
        guard let data = defaults.data(forKey: dailyEntriesKey),
              let entries = try? JSONDecoder().decode([DailyEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    func saveDailyEntries(_ entries: [DailyEntry]) {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: dailyEntriesKey)
    }
    
    func getEntry(for date: Date) -> DailyEntry? {
        let calendar = Calendar.current
        if calendar.isDateInToday(date), let today = loadTodayEntry() {
            return today
        }
        return loadDailyEntries().first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
        func loadSampleData() {
        let habits = SampleData.makeSampleHabits()
        let habitIds = habits.map(\.id)
        let entries = SampleData.makeSampleDailyEntries(habitIds: habitIds)
        let todayEntry = SampleData.makeSampleTodayEntry(habitIds: habitIds)
        
        saveHabits(habits)
        saveDailyEntries(entries)
        saveTodayEntry(todayEntry)
    }
}
