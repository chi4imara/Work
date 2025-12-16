import Foundation
import SwiftUI
import Combine

struct GratitudeEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var text: String
    let createdAt: Date
    var updatedAt: Date
    
    init(date: Date, text: String) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.text = text
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    var shortText: String {
        if text.count > 60 {
            return String(text.prefix(60)) + "..."
        }
        return text
    }
}

struct GratitudeStatistics {
    let totalDays: Int
    let currentStreak: Int
    let bestStreak: Int
    let weekdayStats: [String: Int]
    let monthlyProgress: MonthlyProgress
    
    struct MonthlyProgress {
        let entriesThisMonth: Int
        let missedDays: Int
        let completionPercentage: Int
    }
}

class GratitudeViewModel: ObservableObject {
    @Published var entries: [GratitudeEntry] = []
    @Published var selectedDate = Date()
    @Published var currentMonth = Date()
    @Published var searchText = ""
    @Published var showingOnboarding = true
    @Published var isLoading = true
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "gratitude_entries"
    private let onboardingKey = "has_seen_onboarding"
    
    init() {
        loadEntries()
        checkOnboardingStatus()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
        }
    }
    
    func addEntry(text: String, for date: Date = Date()) {
        let entry = GratitudeEntry(date: date, text: text)
        
        entries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: date) }
        
        entries.append(entry)
        entries.sort { $0.date > $1.date }
        saveEntries()
    }
    
    func updateEntry(_ entry: GratitudeEntry, text: String) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].text = text
            entries[index].updatedAt = Date()
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: GratitudeEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func getEntry(for date: Date) -> GratitudeEntry? {
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func hasEntry(for date: Date) -> Bool {
        return entries.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getDaysInMonth(_ date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start ?? date
        let range = calendar.range(of: .day, in: .month, for: date) ?? 1..<32
        
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    func clearMonth(_ date: Date) {
        let calendar = Calendar.current
        entries.removeAll { entry in
            calendar.isDate(entry.date, equalTo: date, toGranularity: .month)
        }
        saveEntries()
    }
    
    var filteredEntries: [GratitudeEntry] {
        if searchText.isEmpty {
            return entries
        }
        return entries.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
    }
    
    func calculateStatistics() -> GratitudeStatistics {
        let totalDays = entries.count
        let currentStreak = calculateCurrentStreak()
        let bestStreak = calculateBestStreak()
        let weekdayStats = calculateWeekdayStats()
        let monthlyProgress = calculateMonthlyProgress()
        
        return GratitudeStatistics(
            totalDays: totalDays,
            currentStreak: currentStreak,
            bestStreak: bestStreak,
            weekdayStats: weekdayStats,
            monthlyProgress: monthlyProgress
        )
    }
    
    private func calculateCurrentStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var currentDate = today
        
        if !hasEntry(for: today) {
            currentDate = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        }
        
        while hasEntry(for: currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return streak
    }
    
    private func calculateBestStreak() -> Int {
        let sortedDates = entries.map { $0.date }.sorted()
        guard !sortedDates.isEmpty else { return 0 }
        
        var bestStreak = 1
        var currentStreak = 1
        let calendar = Calendar.current
        
        for i in 1..<sortedDates.count {
            let previousDate = sortedDates[i-1]
            let currentDate = sortedDates[i]
            
            if calendar.dateComponents([.day], from: previousDate, to: currentDate).day == 1 {
                currentStreak += 1
                bestStreak = max(bestStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return bestStreak
    }
    
    private func calculateWeekdayStats() -> [String: Int] {
        let calendar = Calendar.current
        let eightWeeksAgo = calendar.date(byAdding: .weekOfYear, value: -8, to: Date()) ?? Date()
        
        let recentEntries = entries.filter { $0.date >= eightWeeksAgo }
        
        var stats: [String: Int] = [
            "Monday": 0, "Tuesday": 0, "Wednesday": 0, "Thursday": 0,
            "Friday": 0, "Saturday": 0, "Sunday": 0
        ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        for entry in recentEntries {
            let weekday = formatter.string(from: entry.date)
            stats[weekday, default: 0] += 1
        }
        
        return stats
    }
    
    private func calculateMonthlyProgress() -> GratitudeStatistics.MonthlyProgress {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let daysInMonth = calendar.range(of: .day, in: .month, for: now)?.count ?? 30
        let dayOfMonth = calendar.component(.day, from: now)
        
        let entriesThisMonth = entries.filter { 
            calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }.count
        
        let missedDays = dayOfMonth - entriesThisMonth
        let completionPercentage = dayOfMonth > 0 ? Int((Double(entriesThisMonth) / Double(dayOfMonth)) * 100) : 0
        
        return GratitudeStatistics.MonthlyProgress(
            entriesThisMonth: entriesThisMonth,
            missedDays: max(0, missedDays),
            completionPercentage: completionPercentage
        )
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([GratitudeEntry].self, from: data) {
            entries = decoded.sorted { $0.date > $1.date }
        }
    }
    
    private func checkOnboardingStatus() {
        showingOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: onboardingKey)
        showingOnboarding = false
    }
}

enum TabSelection: CaseIterable {
    case calendar
    case history
    case statistics
    case settings
    case placeholder
    
    var title: String {
        switch self {
        case .calendar: return "Calendar"
        case .history: return "History"
        case .statistics: return "Statistics"
        case .settings: return "Settings"
        case .placeholder: return ""
        }
    }
    
    var systemImage: String {
        switch self {
        case .calendar: return "calendar"
        case .history: return "magnifyingglass"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
        case .placeholder: return "circle"
        }
    }
}
