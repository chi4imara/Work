import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let goalsKey = "saved_goals"
    private let entriesKey = "daily_entries"
    
    private init() {}
    
    func saveGoal(_ goal: Goal) {
        var goals = getAllGoals()
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        } else {
            goals.append(goal)
        }
        saveGoals(goals)
    }
    
    func getAllGoals() -> [Goal] {
        guard let data = userDefaults.data(forKey: goalsKey),
              let goals = try? JSONDecoder().decode([Goal].self, from: data) else {
            return createDefaultGoals()
        }
        return goals
    }
    
    func updateGoal(_ goal: Goal) {
        saveGoal(goal)
    }
    
    func deleteGoal(_ goalId: UUID) {
        var goals = getAllGoals()
        goals.removeAll { $0.id == goalId }
        saveGoals(goals)
    }
    
    func getTodayGoals() -> [Goal] {
        let allGoals = getAllGoals()
        return allGoals.filter { goal in
            switch goal.frequency {
            case .daily:
                return true
            case .weekly:
                let weekday = Calendar.current.component(.weekday, from: Date())
                return [2, 4, 6].contains(weekday)
            case .once:
                return !goal.isCompleted
            }
        }
    }
    
    private func saveGoals(_ goals: [Goal]) {
        if let data = try? JSONEncoder().encode(goals) {
            userDefaults.set(data, forKey: goalsKey)
        }
    }
    
    private func createDefaultGoals() -> [Goal] {
        let defaultGoals = [
            Goal(title: "Morning walk", category: .body, frequency: .daily, description: "Take a refreshing morning walk"),
            Goal(title: "Coffee with a friend", category: .social, frequency: .weekly, description: "Enjoy quality time with friends"),
            Goal(title: "Mini meditation", category: .soul, frequency: .daily, description: "5 minutes of mindfulness"),
            Goal(title: "Read a book", category: .hobby, frequency: .daily, description: "Read at least 10 pages"),
            Goal(title: "Gratitude journal", category: .soul, frequency: .daily, description: "Write 3 things you're grateful for")
        ]
        saveGoals(defaultGoals)
        return defaultGoals
    }
    
    func getTodayEntry() -> DailyEntry {
        let today = Calendar.current.startOfDay(for: Date())
        let entries = getAllEntries()
        
        if let todayEntry = entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            return todayEntry
        } else {
            let newEntry = DailyEntry(date: today)
            return newEntry
        }
    }
    
    func saveTodayEntry(_ entry: DailyEntry) {
        var entries = getAllEntries()
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
        
        saveEntries(entries)
    }
    
    func getAllEntries() -> [DailyEntry] {
        guard let data = userDefaults.data(forKey: entriesKey),
              let entries = try? JSONDecoder().decode([DailyEntry].self, from: data) else {
            return []
        }
        return entries.sorted { $0.date > $1.date }
    }
    
    func getEntriesForMonth(_ date: Date) -> [DailyEntry] {
        let entries = getAllEntries()
        return entries.filter { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) }
    }
    
    private func saveEntries(_ entries: [DailyEntry]) {
        if let data = try? JSONEncoder().encode(entries) {
            userDefaults.set(data, forKey: entriesKey)
        }
    }
    
    func loadSampleData() {
        let (goals, entries) = SampleData.makeSampleData()
        saveGoals(goals)
        saveEntries(entries)
    }
}
