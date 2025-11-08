import Foundation
import UserNotifications
import Combine

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized: Bool = false
    @Published var dailyReminderEnabled: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var weekendReminders: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var morningTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date() {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var eveningTime: Date = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date() {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var selectedFrequency: Frequency = .daily {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadSettings()
        updateAuthorizationStatus()
    }
    
    private func loadSettings() {
        dailyReminderEnabled = userDefaults.bool(forKey: "daily_reminder_enabled")
        weekendReminders = userDefaults.bool(forKey: "weekend_reminders")
        
        if let morningData = userDefaults.data(forKey: "morning_time"),
           let morning = try? JSONDecoder().decode(Date.self, from: morningData) {
            morningTime = morning
        }
        
        if let eveningData = userDefaults.data(forKey: "evening_time"),
           let evening = try? JSONDecoder().decode(Date.self, from: eveningData) {
            eveningTime = evening
        }
        
        if let frequencyRaw = userDefaults.string(forKey: "selected_frequency"),
           let frequency = Frequency(rawValue: frequencyRaw) {
            selectedFrequency = frequency
        }
    }
    
    func saveSettings() {
        userDefaults.set(dailyReminderEnabled, forKey: "daily_reminder_enabled")
        userDefaults.set(weekendReminders, forKey: "weekend_reminders")
        
        if let morningData = try? JSONEncoder().encode(morningTime) {
            userDefaults.set(morningData, forKey: "morning_time")
        }
        
        if let eveningData = try? JSONEncoder().encode(eveningTime) {
            userDefaults.set(eveningData, forKey: "evening_time")
        }
        
        userDefaults.set(selectedFrequency.rawValue, forKey: "selected_frequency")
        
        scheduleNotifications()
    }
    
    func updateAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func scheduleNotifications() {
        guard isAuthorized && dailyReminderEnabled else { return }
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        scheduleNotification(
            id: "morning_reminder",
            title: "Good Morning!",
            body: "How are you feeling today? Log your mood and weather.",
            time: morningTime
        )
        
        scheduleNotification(
            id: "evening_reminder",
            title: "Evening Check-in",
            body: "How was your day? Don't forget to log your mood.",
            time: eveningTime
        )
    }
    
    private func scheduleNotification(id: String, title: String, body: String, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    enum Frequency: String, CaseIterable {
        case daily = "daily"
        case weekdays = "weekdays"
        case custom = "custom"
        
        var displayName: String {
            switch self {
            case .daily: return "Daily"
            case .weekdays: return "Weekdays Only"
            case .custom: return "Custom"
            }
        }
        
        var description: String {
            switch self {
            case .daily: return "Every day including weekends"
            case .weekdays: return "Monday to Friday only"
            case .custom: return "Set your own schedule"
            }
        }
    }
}
