import Foundation
import SwiftUI
import Combine

class MoodDataManager: ObservableObject {
    static let shared = MoodDataManager()
    
    @Published var moodEntries: [MoodEntry] = []
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "mood_entries"
    
    init() {
        loadEntries()
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(moodEntries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            moodEntries = decoded
        }
    }
    
    func addOrUpdateEntry(date: Date, moodColor: MoodColor, note: String) {
        let calendar = Calendar.current
        
        if let existingIndex = moodEntries.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            moodEntries[existingIndex] = MoodEntry(
                date: date,
                moodColor: moodColor,
                note: note,
                isFavorite: moodEntries[existingIndex].isFavorite
            )
        } else {
            let newEntry = MoodEntry(date: date, moodColor: moodColor, note: note)
            moodEntries.append(newEntry)
        }
        
        saveEntries()
    }
    
    func deleteEntry(for date: Date) {
        let calendar = Calendar.current
        moodEntries.removeAll { calendar.isDate($0.date, inSameDayAs: date) }
        saveEntries()
    }
    
    func toggleFavorite(for date: Date) {
        let calendar = Calendar.current
        if let index = moodEntries.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            moodEntries[index].isFavorite.toggle()
            moodEntries[index].updatedAt = Date()
            saveEntries()
        }
    }
    
    func clearMonth(for date: Date) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        moodEntries.removeAll { entry in
            let entryMonth = calendar.component(.month, from: entry.date)
            let entryYear = calendar.component(.year, from: entry.date)
            return entryMonth == month && entryYear == year
        }
        
        saveEntries()
    }
    
    func getEntry(for date: Date) -> MoodEntry? {
        let calendar = Calendar.current
        return moodEntries.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func getFavoriteEntries() -> [MoodEntry] {
        return moodEntries.filter { $0.isFavorite }.sorted { $0.date > $1.date }
    }
    
    func getEntriesForMonth(_ date: Date) -> [MoodEntry] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        return moodEntries.filter { entry in
            let entryMonth = calendar.component(.month, from: entry.date)
            let entryYear = calendar.component(.year, from: entry.date)
            return entryMonth == month && entryYear == year
        }
    }
    
    func getTotalDaysCount() -> Int {
        return moodEntries.count
    }
    
    func getFavoritesCount() -> Int {
        return moodEntries.filter { $0.isFavorite }.count
    }
    
    func getLastEntryDate() -> Date? {
        return moodEntries.max(by: { $0.date < $1.date })?.date
    }
    
    func getColorDistribution() -> [(MoodColor, Int)] {
        let colorCounts = Dictionary(grouping: moodEntries, by: { $0.moodColor })
            .mapValues { $0.count }
        
        return colorCounts.sorted { $0.value > $1.value }
    }
    
    func getCurrentStreak() -> Int {
        let calendar = Calendar.current
        let sortedEntries = moodEntries.sorted { $0.date > $1.date }
        
        var streak = 0
        var currentDate = Date()
        
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
    
    func getMaxStreak() -> Int {
        let calendar = Calendar.current
        let sortedEntries = moodEntries.sorted { $0.date < $1.date }
        
        var maxStreak = 0
        var currentStreak = 0
        var lastDate: Date?
        
        for entry in sortedEntries {
            if let last = lastDate {
                let daysDifference = calendar.dateComponents([.day], from: last, to: entry.date).day ?? 0
                if daysDifference == 1 {
                    currentStreak += 1
                } else {
                    maxStreak = max(maxStreak, currentStreak)
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }
            lastDate = entry.date
        }
        
        return max(maxStreak, currentStreak)
    }
}
