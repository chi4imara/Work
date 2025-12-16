import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var appState: AppState = .splash
    @Published var isFirstLaunch: Bool = true
    
    init() {
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        isFirstLaunch = false
        appState = .main
    }
    
    func completeSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.appState = self.isFirstLaunch ? .onboarding : .main
        }
    }
}

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var dayEntries: [DayEntry] = []
    @Published var userValues: [UserValue] = []
    @Published var supportPhrases: [SupportPhrase] = []
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadData()
        initializeDefaultValues()
    }
    
    private func loadData() {
        if let data = userDefaults.data(forKey: "dayEntries"),
           let entries = try? JSONDecoder().decode([DayEntry].self, from: data) {
            dayEntries = entries
        }
        
        if let data = userDefaults.data(forKey: "userValues"),
           let values = try? JSONDecoder().decode([UserValue].self, from: data) {
            userValues = values
        }
        
        if let data = userDefaults.data(forKey: "supportPhrases"),
           let phrases = try? JSONDecoder().decode([SupportPhrase].self, from: data) {
            supportPhrases = phrases
        }
    }
    
    private func saveData() {
        if let data = try? JSONEncoder().encode(dayEntries) {
            userDefaults.set(data, forKey: "dayEntries")
        }
        
        if let data = try? JSONEncoder().encode(userValues) {
            userDefaults.set(data, forKey: "userValues")
        }
        
        if let data = try? JSONEncoder().encode(supportPhrases) {
            userDefaults.set(data, forKey: "supportPhrases")
        }
    }
    
    private func initializeDefaultValues() {
        if userValues.isEmpty {
            userValues = DefaultValues.defaultPrinciples.map { UserValue(text: $0) }
        }
        
        if supportPhrases.isEmpty {
            supportPhrases = DefaultValues.defaultSupportPhrases.map { SupportPhrase(text: $0) }
        }
        
        saveData()
    }
    
    func getTodayEntry() -> DayEntry {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let entry = dayEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            return entry
        } else {
            let newEntry = DayEntry(date: today)
            dayEntries.append(newEntry)
            saveData()
            return newEntry
        }
    }
    
    func updateTodayEntry(_ entry: DayEntry) {
        if let index = dayEntries.firstIndex(where: { $0.id == entry.id }) {
            dayEntries[index] = entry
        } else {
            dayEntries.append(entry)
        }
        saveData()
    }
    
    func getEntryForDate(_ date: Date) -> DayEntry? {
        return dayEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getStatistics() -> Statistics {
        let habitStats = calculateHabitStats()
        let totalDays = dayEntries.filter { $0.hasAnyChecked }.count
        let currentStreak = calculateCurrentStreak()
        let thisWeekCount = calculateThisWeekCount()
        let thisMonthCount = calculateThisMonthCount()
        
        return Statistics(
            habitStats: habitStats,
            totalDays: totalDays,
            currentStreak: currentStreak,
            thisWeekCount: thisWeekCount,
            thisMonthCount: thisMonthCount
        )
    }
    
    private func calculateHabitStats() -> [String: Int] {
        var stats: [String: Int] = [:]
        
        for habit in Habit.defaultHabits {
            let count = dayEntries.filter { $0.checkedHabits.contains(habit.title) }.count
            stats[habit.title] = count
        }
        
        return stats
    }
    
    private func calculateCurrentStreak() -> Int {
        let sortedEntries = dayEntries
            .filter { $0.hasAnyChecked }
            .sorted { $0.date > $1.date }
        
        var streak = 0
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: Date())
        
        for entry in sortedEntries {
            if calendar.isDate(entry.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func calculateThisWeekCount() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        
        return dayEntries.filter { entry in
            entry.hasAnyChecked && entry.date >= weekStart
        }.count
    }
    
    private func calculateThisMonthCount() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
        
        return dayEntries.filter { entry in
            entry.hasAnyChecked && entry.date >= monthStart
        }.count
    }
    
    func addUserValue(_ text: String) {
        let value = UserValue(text: text)
        userValues.append(value)
        saveData()
    }
    
    func deleteUserValue(_ value: UserValue) {
        userValues.removeAll { $0.id == value.id }
        saveData()
    }
    
    func addSupportPhrase(_ text: String) {
        let phrase = SupportPhrase(text: text)
        supportPhrases.append(phrase)
        saveData()
    }
    
    func deleteSupportPhrase(_ phrase: SupportPhrase) {
        supportPhrases.removeAll { $0.id == phrase.id }
        saveData()
    }
    
    func getRandomInspirationalPhrase() -> String {
        let allPhrases = userValues.map { $0.text } + DefaultValues.inspirationalPhrases
        return allPhrases.randomElement() ?? "Today it's enough to just be attentive."
    }
}

class SettingsViewModel: ObservableObject {
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
