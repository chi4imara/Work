import Foundation
import UserNotifications
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private enum Keys {
        static let rituals = "saved_rituals"
        static let dailyEntries = "daily_entries"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let hasLaunchedBefore = "hasLaunchedBefore"
    }
    
    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func saveRituals(_ rituals: [Ritual]) {
        do {
            let data = try encoder.encode(rituals)
            userDefaults.set(data, forKey: Keys.rituals)
            userDefaults.synchronize()
            print("Successfully saved \(rituals.count) rituals to UserDefaults")
        } catch {
            print("Failed to save rituals: \(error)")
        }
    }
    
    func loadRituals() -> [Ritual] {
        guard let data = userDefaults.data(forKey: Keys.rituals) else {
            print("No rituals data found in UserDefaults")
            return []
        }
        
        do {
            let rituals = try decoder.decode([Ritual].self, from: data)
            print("Successfully loaded \(rituals.count) rituals from UserDefaults")
            return rituals
        } catch {
            print("Failed to load rituals: \(error)")
            return []
        }
    }
    
    func saveDailyEntries(_ entries: [DailyEntry]) {
        do {
            let data = try encoder.encode(entries)
            userDefaults.set(data, forKey: Keys.dailyEntries)
            userDefaults.synchronize()
            print("Successfully saved \(entries.count) daily entries to UserDefaults")
        } catch {
            print("Failed to save daily entries: \(error)")
        }
    }
    
    func loadDailyEntries() -> [DailyEntry] {
        guard let data = userDefaults.data(forKey: Keys.dailyEntries) else {
            print("No daily entries data found in UserDefaults")
            return []
        }
        
        do {
            let entries = try decoder.decode([DailyEntry].self, from: data)
            print("Successfully loaded \(entries.count) daily entries from UserDefaults")
            return entries
        } catch {
            print("Failed to load daily entries: \(error)")
            return []
        }
    }
    
    func saveTodayEntry(_ entry: DailyEntry) {
        var entries = loadDailyEntries()
        let calendar = Calendar.current
        
        entries.removeAll { calendar.isDate($0.date, inSameDayAs: entry.date) }
        
        entries.append(entry)
        
        saveDailyEntries(entries)
    }
    
    func getTodayEntry() -> DailyEntry? {
        let entries = loadDailyEntries()
        let today = Calendar.current.startOfDay(for: Date())
        
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    func setOnboardingCompleted(_ completed: Bool) {
        userDefaults.set(completed, forKey: Keys.hasCompletedOnboarding)
        userDefaults.set(true, forKey: Keys.hasLaunchedBefore)
    }
    
    func hasCompletedOnboarding() -> Bool {
        return userDefaults.bool(forKey: Keys.hasCompletedOnboarding)
    }
    
    func isFirstLaunch() -> Bool {
        return !userDefaults.bool(forKey: Keys.hasLaunchedBefore)
    }
    
    func getStreakCount() -> Int {
        let entries = loadDailyEntries()
        let calendar = Calendar.current
        let sortedEntries = entries.sorted { $0.date > $1.date }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for entry in sortedEntries {
            if calendar.isDate(entry.date, inSameDayAs: currentDate) && entry.isComplete {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    func getCompletionRate(for period: StatsPeriod) -> Double {
        let entries = loadDailyEntries()
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        let filteredEntries = entries.filter { $0.date >= startDate }
        let completedEntries = filteredEntries.filter { $0.isComplete }
        
        guard !filteredEntries.isEmpty else { return 0.0 }
        return Double(completedEntries.count) / Double(filteredEntries.count)
    }
    
    func getMoodDistribution() -> [String: Int] {
        let entries = loadDailyEntries()
        var distribution: [String: Int] = [:]
        
        for entry in entries {
            if let mood = entry.mood {
                distribution[mood.name, default: 0] += 1
            }
        }
        
        return distribution
    }
}

enum StatsPeriod {
    case week, month, year
}

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Time for self-care"
        content.body = "How are you feeling today? Take a moment to check in with yourself."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19 
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
