import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var entries: [WonderEntry] = []
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "WonderEntries"
    private let onboardingKey = "OnboardingComplete"
    
    private init() {
        loadEntries()
    }
    
    func addEntry(_ entry: WonderEntry) {
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: WonderEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: WonderEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteEntry(at indexSet: IndexSet) {
        entries.remove(atOffsets: indexSet)
        saveEntries()
    }
    
    func getEntries(for period: TimePeriod, sortOrder: SortOrder = .newest) -> [WonderEntry] {
        let filteredEntries = filterEntries(for: period)
        return sortEntries(filteredEntries, by: sortOrder)
    }
    
    func searchEntries(query: String, period: TimePeriod = .all) -> [WonderEntry] {
        let filteredEntries = filterEntries(for: period)
        
        if query.isEmpty {
            return filteredEntries
        }
        
        return filteredEntries.filter { entry in
            entry.title.localizedCaseInsensitiveContains(query) ||
            entry.description.localizedCaseInsensitiveContains(query)
        }
    }
    
    private func filterEntries(for period: TimePeriod) -> [WonderEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .today:
            return entries.filter { calendar.isDate($0.date, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -6, to: now) ?? now
            return entries.filter { $0.date >= calendar.startOfDay(for: weekAgo) }
        case .month:
            let monthAgo = calendar.date(byAdding: .day, value: -30, to: now) ?? now
            return entries.filter { $0.date >= calendar.startOfDay(for: monthAgo) }
        case .all:
            return entries
        }
    }
    
    private func sortEntries(_ entries: [WonderEntry], by sortOrder: SortOrder) -> [WonderEntry] {
        switch sortOrder {
        case .newest:
            return entries.sorted { $0.createdAt > $1.createdAt }
        case .oldest:
            return entries.sorted { $0.createdAt < $1.createdAt }
        }
    }
    
    func getStatistics(for period: TimePeriod) -> WonderStatistics {
        let entries = getEntries(for: period)
        let totalEntries = entries.count
        
        let uniqueDates = Set(entries.map { Calendar.current.startOfDay(for: $0.date) })
        let activeDays = uniqueDates.count
        
        let averagePerDay = activeDays > 0 ? totalEntries / activeDays : 0
        
        let dailyData = getDailyData(for: period, entries: entries)
        
        return WonderStatistics(
            totalEntries: totalEntries,
            activeDays: activeDays,
            averagePerDay: averagePerDay,
            dailyData: dailyData
        )
    }
    
    private func getDailyData(for period: TimePeriod, entries: [WonderEntry]) -> [DailyData] {
        let calendar = Calendar.current
        let now = Date()
        
        let dates: [Date]
        switch period {
        case .today:
            dates = [calendar.startOfDay(for: now)]
        case .week:
            dates = (0..<7).compactMap { calendar.date(byAdding: .day, value: -$0, to: now) }
                .map { calendar.startOfDay(for: $0) }
                .reversed()
        case .month:
            dates = (0..<31).compactMap { calendar.date(byAdding: .day, value: -$0, to: now) }
                .map { calendar.startOfDay(for: $0) }
                .reversed()
        case .all:
            let allDates = entries.map { calendar.startOfDay(for: $0.date) }
            let minDate = allDates.min() ?? now
            let maxDate = allDates.max() ?? now
            
            var currentDate = minDate
            var allDatesList: [Date] = []
            
            while currentDate <= maxDate {
                allDatesList.append(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            }
            dates = allDatesList
        }
        
        return dates.map { date in
            let count = entries.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
            return DailyData(date: date, count: count)
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([WonderEntry].self, from: data) {
            entries = decoded
        }
    }
    
    var isOnboardingComplete: Bool {
        get { 
            let value = userDefaults.bool(forKey: onboardingKey)
            print("Getting isOnboardingComplete: \(value)")
            return value
        }
        set { 
            print("Setting isOnboardingComplete to: \(newValue)")
            userDefaults.set(newValue, forKey: onboardingKey)
        }
    }
}

struct WonderStatistics {
    let totalEntries: Int
    let activeDays: Int
    let averagePerDay: Int
    let dailyData: [DailyData]
}

struct DailyData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
    }
    
    var fullDisplayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
