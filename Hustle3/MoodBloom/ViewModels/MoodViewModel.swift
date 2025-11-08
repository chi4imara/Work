import Foundation
import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var moodEntries: [MoodEntry] = []
    @Published var selectedDate = Date()
    @Published var currentMonth = Date()
    
    private let userDefaults = UserDefaults.standard
    private let moodEntriesKey = "MoodEntries"
    
    init() {
        loadMoodEntries()
    }
    
    func loadMoodEntries() {
        if let data = userDefaults.data(forKey: moodEntriesKey),
           let entries = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            self.moodEntries = entries
        }
    }
    
    func saveMoodEntries() {
        if let data = try? JSONEncoder().encode(moodEntries) {
            userDefaults.set(data, forKey: moodEntriesKey)
        }
    }
    
    func addOrUpdateMoodEntry(for date: Date, mood: MoodType, comment: String, photoIds: [String] = []) {
        let calendar = Calendar.current
        
        let oldEntry = moodEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
        
        moodEntries.removeAll { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
        
        var newEntry = MoodEntry(date: date, mood: mood, comment: comment)
        newEntry.photoIds = photoIds
        moodEntries.append(newEntry)
        moodEntries.sort { $0.date > $1.date }
        
        if let oldEntry = oldEntry {
            let unusedPhotoIds = Set(oldEntry.photoIds).subtracting(Set(photoIds))
            PhotoManager.shared.deletePhotos(with: Array(unusedPhotoIds))
        }
        
        saveMoodEntries()
    }
    
    func deleteMoodEntry(for date: Date) {
        let calendar = Calendar.current
        
        let entryToDelete = moodEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
        
        moodEntries.removeAll { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
        
        if let entry = entryToDelete {
            PhotoManager.shared.deletePhotos(with: entry.photoIds)
        }
        
        saveMoodEntries()
    }
    
    func getMoodEntry(for date: Date) -> MoodEntry? {
        let calendar = Calendar.current
        return moodEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
        
    func getRecentEntries(limit: Int = 7) -> [MoodEntry] {
        return Array(moodEntries.prefix(limit))
    }
    
    func getEntriesForMonth(_ date: Date) -> [MoodEntry] {
        let calendar = Calendar.current
        return moodEntries.filter { entry in
            calendar.isDate(entry.date, equalTo: date, toGranularity: .month)
        }
    }
    
    func canAddEntry(for date: Date) -> Bool {
        return date <= Date()
    }
        
    func getEntriesForPeriod(_ period: AnalyticsPeriod, from date: Date = Date()) -> [MoodEntry] {
        let calendar = Calendar.current
        let startDate: Date
        
        switch period {
        case .week:
            startDate = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
        case .month:
            startDate = calendar.dateInterval(of: .month, for: date)?.start ?? date
        case .year:
            startDate = calendar.dateInterval(of: .year, for: date)?.start ?? date
        }
        
        return moodEntries.filter { entry in
            entry.date >= startDate && entry.date <= date
        }.sorted { $0.date < $1.date }
    }
    
    func getAverageMood(for entries: [MoodEntry]) -> Double {
        guard !entries.isEmpty else { return 0 }
        let sum = entries.reduce(0) { $0 + $1.moodValue }
        return Double(sum) / Double(entries.count)
    }
    
    func getMostFrequentMood(for entries: [MoodEntry]) -> MoodType? {
        guard !entries.isEmpty else { return nil }
        
        let moodCounts = Dictionary(grouping: entries, by: { $0.mood })
            .mapValues { $0.count }
        
        return moodCounts.max(by: { $0.value < $1.value })?.key
    }
    
    func getBestDay(for entries: [MoodEntry]) -> MoodEntry? {
        return entries.max(by: { $0.moodValue < $1.moodValue })
    }
    
    func getWorstDay(for entries: [MoodEntry]) -> MoodEntry? {
        return entries.min(by: { $0.moodValue < $1.moodValue })
    }
}

enum AnalyticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
