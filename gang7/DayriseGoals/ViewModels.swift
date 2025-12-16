import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var showOnboarding = true
    @Published var showSplash = true
    @Published var selectedTab = 0
    
    init() {
        checkOnboardingStatus()
    }
    
    private func checkOnboardingStatus() {
        showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        showOnboarding = false
    }
    
    func completeSplash() {
        showSplash = false
    }
}

class DailyEntryViewModel: ObservableObject {
    @Published var currentEntry: DailyEntry?
    @Published var todayReminder: String = ""
    @Published var todayIntention: String = ""
    @Published var todayMood: String = ""
    @Published var todayGratitude: String = ""
    @Published var entries: [DailyEntry] = []
    
    private let calendar = Calendar.current
    
    init() {
        loadTodayEntry()
        loadAllEntries()
    }
    
    var isToday: Bool {
        guard let entry = currentEntry else { return true }
        return calendar.isDateInToday(entry.date)
    }
    
    func loadTodayEntry() {
        let today = Date()
        let todayKey = dateKey(for: today)
        
        if let data = UserDefaults.standard.data(forKey: "entry_\(todayKey)"),
           let entry = try? JSONDecoder().decode(DailyEntry.self, from: data) {
            currentEntry = entry
            todayReminder = entry.reminder
            todayIntention = entry.intention
            todayMood = entry.mood ?? ""
            todayGratitude = entry.gratitude ?? ""
        } else {
            generateTodayReminder()
        }
    }
    
    func generateTodayReminder() {
        let today = Date()
        let todayKey = dateKey(for: today)
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let yesterdayKey = dateKey(for: yesterday)
        var yesterdayReminder = ""
        
        if let data = UserDefaults.standard.data(forKey: "entry_\(yesterdayKey)"),
           let entry = try? JSONDecoder().decode(DailyEntry.self, from: data) {
            yesterdayReminder = entry.reminder
        }
        
        var availableReminders = AppData.morningReminders.filter { $0 != yesterdayReminder }
        if availableReminders.isEmpty {
            availableReminders = AppData.morningReminders
        }
        
        todayReminder = availableReminders.randomElement() ?? "Start your day with breathing and silence."
    }
    
    func updateIntention(_ text: String) {
        todayIntention = text
        saveCurrentEntry()
    }
    
    func updateMood(_ mood: String) {
        todayMood = mood
        saveCurrentEntry()
    }
    
    func updateGratitude(_ text: String) {
        todayGratitude = text
        saveCurrentEntry()
    }
    
    private func saveCurrentEntry() {
        let today = Date()
        let entry = DailyEntry(
            date: today,
            reminder: todayReminder,
            intention: todayIntention,
            mood: todayMood.isEmpty ? nil : todayMood,
            gratitude: todayGratitude.isEmpty ? nil : todayGratitude
        )
        
        currentEntry = entry
        
        let todayKey = dateKey(for: today)
        if let data = try? JSONEncoder().encode(entry) {
            UserDefaults.standard.set(data, forKey: "entry_\(todayKey)")
        }
        
        loadAllEntries()
    }
    
    func loadAllEntries() {
        var loadedEntries: [DailyEntry] = []
        
        let today = Date()
        for i in 0..<365 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let key = dateKey(for: date)
                if let data = UserDefaults.standard.data(forKey: "entry_\(key)"),
                   let entry = try? JSONDecoder().decode(DailyEntry.self, from: data) {
                    loadedEntries.append(entry)
                }
            }
        }
        
        entries = loadedEntries.sorted { $0.date > $1.date }
    }
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

class QuotesViewModel: ObservableObject {
    @Published var currentQuoteIndex = 0
    
    var currentQuote: Quote {
        AppData.quotes[currentQuoteIndex]
    }
    
    func nextQuote() {
        currentQuoteIndex = (currentQuoteIndex + 1) % AppData.quotes.count
    }
    
    func previousQuote() {
        currentQuoteIndex = currentQuoteIndex > 0 ? currentQuoteIndex - 1 : AppData.quotes.count - 1
    }
}

class SettingsViewModel: ObservableObject {
    let settingsItems = [
        SettingsItem(title: "Terms and Conditions", action: .termsAndConditions),
        SettingsItem(title: "Privacy Policy", action: .privacyPolicy),
        SettingsItem(title: "Contact Email", action: .contactEmail),
        SettingsItem(title: "Rate App", action: .rateApp)
    ]
    
    func handleAction(_ action: SettingsAction) {
        switch action {
        case .termsAndConditions:
            if let url = URL(string: "https://www.privacypolicies.com/live/a98ab5a9-201e-4a33-8b2f-54983e80e47c") {
                UIApplication.shared.open(url)
            }
        case .privacyPolicy:
            if let url = URL(string: "https://www.privacypolicies.com/live/15eaedce-0c7f-4ee5-a121-d2bd44d3e4f7") {
                UIApplication.shared.open(url)
            }
        case .contactEmail:
            if let url = URL(string: "https://www.privacypolicies.com/live/15eaedce-0c7f-4ee5-a121-d2bd44d3e4f7") {
                UIApplication.shared.open(url)
            }
        case .rateApp:
            requestReview()
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
