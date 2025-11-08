import Foundation
import SwiftUI
import Combine

class GratitudeViewModel: ObservableObject {
    @Published var entries: [GratitudeEntry] = []
    @Published var selectedDate = Date()
    @Published var currentMonth = Date()
    
    private let dataManager = DataManager.shared
    
    init() {
        loadEntries()
    }
    
    func saveEntry(_ entry: GratitudeEntry) {
        if let index = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: entry.date) }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
        entries.sort { $0.date > $1.date }
        saveEntries()
    }
    
    func deleteEntry(for date: Date) {
        entries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: date) }
        saveEntries()
    }
    
    func getEntry(for date: Date) -> GratitudeEntry? {
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func hasEntry(for date: Date) -> Bool {
        return entries.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    func goToToday() {
        currentMonth = Date()
        selectedDate = Date()
    }
    
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    var totalDaysWithEntries: Int {
        entries.count
    }
    
    var lastEntryDate: Date? {
        entries.first?.date
    }
    
    var currentStreak: Int {
        guard !entries.isEmpty else { return 0 }
        
        let sortedEntries = entries.sorted { $0.date > $1.date }
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        
        while let entry = sortedEntries.first(where: { calendar.isDate($0.date, inSameDayAs: currentDate) }) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return streak
    }
    
    var maxStreak: Int {
        guard !entries.isEmpty else { return 0 }
        
        let sortedEntries = entries.sorted { $0.date < $1.date }
        let calendar = Calendar.current
        var maxStreak = 0
        var currentStreak = 1
        
        for i in 1..<sortedEntries.count {
            let previousDate = sortedEntries[i-1].date
            let currentDate = sortedEntries[i].date
            
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: previousDate),
               calendar.isDate(nextDay, inSameDayAs: currentDate) {
                currentStreak += 1
            } else {
                maxStreak = max(maxStreak, currentStreak)
                currentStreak = 1
            }
        }
        
        return max(maxStreak, currentStreak)
    }
    
    func getEntriesCount(for period: StatisticsPeriod, in timeFrame: Date) -> [StatisticsDataPoint] {
        let calendar = Calendar.current
        var dataPoints: [StatisticsDataPoint] = []
        
        switch period {
        case .week:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: timeFrame)?.start ?? timeFrame
            for i in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                    let count = entries.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
                    dataPoints.append(StatisticsDataPoint(date: date, count: count))
                }
            }
        case .month:
            let startOfMonth = calendar.dateInterval(of: .month, for: timeFrame)?.start ?? timeFrame
            let range = calendar.range(of: .day, in: .month, for: timeFrame) ?? 1..<32
            for day in range {
                if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                    let count = entries.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
                    dataPoints.append(StatisticsDataPoint(date: date, count: count))
                }
            }
        case .year:
            let startOfYear = calendar.dateInterval(of: .year, for: timeFrame)?.start ?? timeFrame
            for month in 0..<12 {
                if let date = calendar.date(byAdding: .month, value: month, to: startOfYear) {
                    let count = entries.filter { calendar.isDate($0.date, equalTo: date, toGranularity: .month) }.count
                    dataPoints.append(StatisticsDataPoint(date: date, count: count))
                }
            }
        }
        
        return dataPoints
    }
    
    private func saveEntries() {
        dataManager.saveEntries(entries)
    }
    
    private func loadEntries() {
        entries = dataManager.loadEntries()
    }
}

enum StatisticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct StatisticsDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
