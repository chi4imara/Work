import Foundation
import SwiftUI
import Combine

class MoodDataManager: ObservableObject {
    @Published var entries: [MoodEntry] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "mood_entries"
    
    init() {
        loadEntries()
    }
    
    private func saveEntries() {
        do {
            let data = try JSONEncoder().encode(entries)
            userDefaults.set(data, forKey: entriesKey)
        } catch {
            print("Failed to save entries: \(error)")
        }
    }
    
    private func loadEntries() {
        guard let data = userDefaults.data(forKey: entriesKey) else { return }
        do {
            entries = try JSONDecoder().decode([MoodEntry].self, from: data)
        } catch {
            print("Failed to load entries: \(error)")
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
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: MoodEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteEntriesForMonth(_ date: Date) {
        let calendar = Calendar.current
        entries.removeAll { entry in
            calendar.isDate(entry.date, equalTo: date, toGranularity: .month)
        }
        saveEntries()
    }
    
    func entryForDate(_ date: Date) -> MoodEntry? {
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func entriesForMonth(_ date: Date) -> [MoodEntry] {
        let calendar = Calendar.current
        return entries.filter { entry in
            calendar.isDate(entry.date, equalTo: date, toGranularity: .month)
        }
    }
    
    func searchEntries(query: String) -> [MoodEntry] {
        if query.isEmpty {
            return entries.sorted { $0.date > $1.date }
        }
        return entries.filter { entry in
            entry.note.localizedCaseInsensitiveContains(query)
        }.sorted { $0.date > $1.date }
    }
    
    func calculateStatistics(for date: Date = Date()) -> MoodStatistics {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let totalEntries = entries.count
        
        var currentStreak = 0
        var checkDate = today
        
        if entryForDate(today) == nil {
            checkDate = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        }
        
        while entryForDate(checkDate) != nil {
            currentStreak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        
        let bestStreak = calculateBestStreak()
        
        let monthlyEntries = entriesForMonth(date)
        var monthlyDistribution: [MoodType: Int] = [:]
        for mood in MoodType.allCases {
            monthlyDistribution[mood] = monthlyEntries.filter { $0.mood == mood }.count
        }
        
        let weeklyDistribution = calculateWeeklyDistribution()
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count ?? 30
        let currentDay = calendar.component(.day, from: Date())
        let passedDays = calendar.isDate(date, equalTo: Date(), toGranularity: .month) ? currentDay : daysInMonth
        let monthlyMissed = passedDays - monthlyEntries.count
        let monthlyCompletion = passedDays > 0 ? Int((Double(monthlyEntries.count) / Double(passedDays)) * 100) : 0
        
        return MoodStatistics(
            totalEntries: totalEntries,
            currentStreak: currentStreak,
            bestStreak: bestStreak,
            monthlyDistribution: monthlyDistribution,
            weeklyDistribution: weeklyDistribution,
            monthlyEntries: monthlyEntries.count,
            monthlyMissed: monthlyMissed,
            monthlyCompletion: monthlyCompletion
        )
    }
    
    private func calculateBestStreak() -> Int {
        let calendar = Calendar.current
        let sortedEntries = entries.sorted { $0.date < $1.date }
        
        var bestStreak = 0
        var currentStreak = 0
        var lastDate: Date?
        
        for entry in sortedEntries {
            if let last = lastDate {
                let daysBetween = calendar.dateComponents([.day], from: last, to: entry.date).day ?? 0
                if daysBetween == 1 {
                    currentStreak += 1
                } else {
                    bestStreak = max(bestStreak, currentStreak)
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }
            lastDate = entry.date
        }
        
        return max(bestStreak, currentStreak)
    }
    
    private func calculateWeeklyDistribution() -> [String: Int] {
        let calendar = Calendar.current
        let eightWeeksAgo = calendar.date(byAdding: .weekOfYear, value: -8, to: Date()) ?? Date()
        
        let recentEntries = entries.filter { $0.date >= eightWeeksAgo }
        var weeklyDistribution: [String: Int] = [:]
        
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        for weekday in weekdays {
            weeklyDistribution[weekday] = 0
        }
        
        for entry in recentEntries {
            let weekday = calendar.component(.weekday, from: entry.date)
            let weekdayName = weekdays[(weekday + 5) % 7] 
            weeklyDistribution[weekdayName, default: 0] += 1
        }
        
        return weeklyDistribution
    }
}
