import SwiftUI
import Foundation
import Combine

class WeatherDataManager: ObservableObject {
    @Published var weatherEntries: [WeatherEntry] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "weather_entries"
    
    init() {
        loadEntries()
    }
    
    func addEntry(date: Date, weatherColor: WeatherColor) {
        print("WeatherDataManager: Adding entry for date: \(date), color: \(weatherColor.displayName)")
        
        let initialCount = weatherEntries.count
        weatherEntries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: date) }
        print("WeatherDataManager: Removed \(initialCount - weatherEntries.count) existing entries")
        
        let entry = WeatherEntry(date: date, weatherColor: weatherColor)
        weatherEntries.append(entry)
        weatherEntries.sort { $0.date > $1.date }
        
        print("WeatherDataManager: Total entries after add: \(weatherEntries.count)")
        saveEntries()
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: NSNotification.Name("WeatherDataUpdated"), object: nil)
        }
    }
    
    func removeEntry(for date: Date) {
        weatherEntries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: date) }
        saveEntries()
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func removeEntry(by id: UUID) {
        weatherEntries.removeAll { $0.id == id }
        saveEntries()
    }
    
    func getEntry(for date: Date) -> WeatherEntry? {
        return weatherEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func hasEntry(for date: Date) -> Bool {
        return weatherEntries.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getTotalDaysCount() -> Int {
        return weatherEntries.count
    }
    
    func getLastEntryDate() -> Date? {
        return weatherEntries.max(by: { $0.date < $1.date })?.date
    }
    
    func getColorDistribution() -> [String: Int] {
        var distribution: [String: Int] = [:]
        
        for entry in weatherEntries {
            let colorName = entry.weatherColor.displayName
            distribution[colorName, default: 0] += 1
        }
        
        return distribution
    }
    
    func getEntriesForPeriod(days: Int) -> [WeatherEntry] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -days, to: endDate) ?? endDate
        
        return weatherEntries.filter { entry in
            entry.date >= startDate && entry.date <= endDate
        }
    }
    
    func getEntriesGroupedByWeek() -> [Date: Int] {
        let calendar = Calendar.current
        var groupedEntries: [Date: Int] = [:]
        
        for entry in weatherEntries {
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: entry.date)?.start ?? entry.date
            groupedEntries[weekStart, default: 0] += 1
        }
        
        return groupedEntries
    }
    
    func getEntriesGroupedByMonth() -> [Date: Int] {
        let calendar = Calendar.current
        var groupedEntries: [Date: Int] = [:]
        
        for entry in weatherEntries {
            let monthStart = calendar.dateInterval(of: .month, for: entry.date)?.start ?? entry.date
            groupedEntries[monthStart, default: 0] += 1
        }
        
        return groupedEntries
    }
    
    private func saveEntries() {
        do {
            let data = try JSONEncoder().encode(weatherEntries)
            userDefaults.set(data, forKey: entriesKey)
        } catch {
            print("Failed to save weather entries: \(error)")
        }
    }
    
    private func loadEntries() {
        guard let data = userDefaults.data(forKey: entriesKey) else { return }
        
        do {
            weatherEntries = try JSONDecoder().decode([WeatherEntry].self, from: data)
            weatherEntries.sort { $0.date > $1.date }
        } catch {
            print("Failed to load weather entries: \(error)")
            weatherEntries = []
        }
    }
}
