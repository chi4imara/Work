import Foundation
import SwiftUI
import Combine

class NoticeViewModel: ObservableObject {
    @Published var entries: [DayEntry] = []
    @Published var currentTimeOfDay: TimeOfDay = .morning
    @Published var showOnboarding = true
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "SavedEntries"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadEntries()
        updateCurrentTimeOfDay()
        checkOnboardingStatus()
        
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.updateCurrentTimeOfDay()
        }
    }
    
    private func checkOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: onboardingKey)
        showOnboarding = false
    }
    
    private func updateCurrentTimeOfDay() {
        currentTimeOfDay = TimeOfDay.current()
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([DayEntry].self, from: data) {
            entries = decodedEntries
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    func getTodayEntry() -> DayEntry {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let existingEntry = entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            return existingEntry
        } else {
            let newEntry = DayEntry(date: today)
            entries.insert(newEntry, at: 0)
            saveEntries()
            return newEntry
        }
    }
    
    func updateEntry(text: String, for timeOfDay: TimeOfDay) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            switch timeOfDay {
            case .morning:
                entries[index] = DayEntry(
                    date: entries[index].date,
                    morningEntry: text.isEmpty ? nil : text,
                    dayEntry: entries[index].dayEntry,
                    eveningEntry: entries[index].eveningEntry
                )
            case .day:
                entries[index] = DayEntry(
                    date: entries[index].date,
                    morningEntry: entries[index].morningEntry,
                    dayEntry: text.isEmpty ? nil : text,
                    eveningEntry: entries[index].eveningEntry
                )
            case .evening:
                entries[index] = DayEntry(
                    date: entries[index].date,
                    morningEntry: entries[index].morningEntry,
                    dayEntry: entries[index].dayEntry,
                    eveningEntry: text.isEmpty ? nil : text
                )
            }
        } else {
            var newEntry = DayEntry(date: today)
            switch timeOfDay {
            case .morning:
                newEntry = DayEntry(
                    date: today,
                    morningEntry: text.isEmpty ? nil : text,
                    dayEntry: nil,
                    eveningEntry: nil
                )
            case .day:
                newEntry = DayEntry(
                    date: today,
                    morningEntry: nil,
                    dayEntry: text.isEmpty ? nil : text,
                    eveningEntry: nil
                )
            case .evening:
                newEntry = DayEntry(
                    date: today,
                    morningEntry: nil,
                    dayEntry: nil,
                    eveningEntry: text.isEmpty ? nil : text
                )
            }
            entries.insert(newEntry, at: 0)
        }
        
        saveEntries()
    }
    
    func getEntry(for timeOfDay: TimeOfDay) -> String {
        let todayEntry = getTodayEntry()
        
        switch timeOfDay {
        case .morning:
            return todayEntry.morningEntry ?? ""
        case .day:
            return todayEntry.dayEntry ?? ""
        case .evening:
            return todayEntry.eveningEntry ?? ""
        }
    }
    
    func searchEntries(query: String) -> [DayEntry] {
        if query.isEmpty {
            return entries
        }
        
        return entries.filter { entry in
            let morningMatch = entry.morningEntry?.localizedCaseInsensitiveContains(query) ?? false
            let dayMatch = entry.dayEntry?.localizedCaseInsensitiveContains(query) ?? false
            let eveningMatch = entry.eveningEntry?.localizedCaseInsensitiveContains(query) ?? false
            
            return morningMatch || dayMatch || eveningMatch
        }
    }
}
