import Foundation
import SwiftUI
import Combine

class PracticeViewModel: ObservableObject {
    @Published var practices: [Practice] = []
    @Published var history: [HistoryEntry] = []
    @Published var streakData = StreakData()
    
    private let practicesKey = "SavedPractices"
    private let historyKey = "SavedHistory"
    private let streakKey = "SavedStreak"
    
    init() {
        loadData()
    }
    
    func addPractice(_ practice: Practice) {
        practices.append(practice)
        saveData()
    }
    
    func updatePractice(_ practice: Practice) {
        if let index = practices.firstIndex(where: { $0.id == practice.id }) {
            practices[index] = practice
            saveData()
        }
    }
    
    func deletePractice(_ practice: Practice) {
        practices.removeAll { $0.id == practice.id }
        history.removeAll { $0.practiceId == practice.id }
        saveData()
    }
    
    func deletePractice(byId id: UUID) {
        practices.removeAll { $0.id == id }
        history.removeAll { $0.practiceId == id }
        saveData()
    }
    
    func practice(byId id: UUID) -> Practice? {
        practices.first { $0.id == id }
    }
    
    func toggleFavorite(_ practice: Practice) {
        if let index = practices.firstIndex(where: { $0.id == practice.id }) {
            practices[index].isFavorite.toggle()
            saveData()
        }
    }
    
    func completePractice(_ practice: Practice, note: String = "") {
        let entry = HistoryEntry(practice: practice, note: note)
        history.append(entry)
        updateStreak()
        saveData()
    }
    
    func getTodaysPractices() -> [Practice] {
        let calendar = Calendar.current
        let today = Date()
        
        return practices.filter { practice in
            switch practice.frequency {
            case .daily:
                return true
            case .severalTimesWeek:
                let todaysEntries = history.filter { entry in
                    calendar.isDate(entry.completedAt, inSameDayAs: today) && entry.practiceId == practice.id
                }
                return todaysEntries.isEmpty
            case .once:
                let completedEntries = history.filter { $0.practiceId == practice.id }
                return completedEntries.isEmpty
            }
        }
    }
    
    func getTodaysCompletedPractices() -> [HistoryEntry] {
        let calendar = Calendar.current
        let today = Date()
        
        return history.filter { calendar.isDate($0.completedAt, inSameDayAs: today) }
    }
    
    func getHistoryForDate(_ date: Date) -> [HistoryEntry] {
        let calendar = Calendar.current
        return history.filter { calendar.isDate($0.completedAt, inSameDayAs: date) }
    }
    
    func getDaysWithEntries() -> Set<Date> {
        let calendar = Calendar.current
        return Set(history.map { calendar.startOfDay(for: $0.completedAt) })
    }
    
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let daysWithEntries = Set(history.map { calendar.startOfDay(for: $0.completedAt) })
        let sortedDays = Array(daysWithEntries).sorted(by: >)
        
        streakData.totalDays = daysWithEntries.count
        
        guard !sortedDays.isEmpty else {
            streakData.currentStreak = 0
            streakData.longestStreak = 0
            return
        }
        
        var currentStreak = 0
        var checkDate = today
        
        while daysWithEntries.contains(checkDate) {
            currentStreak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        
        streakData.currentStreak = currentStreak
        
        var longestStreak = 0
        var tempStreak = 0
        var previousDate: Date?
        
        for date in sortedDays.reversed() {
            if let prev = previousDate {
                let daysDifference = calendar.dateComponents([.day], from: prev, to: date).day ?? 0
                if daysDifference == 1 {
                    tempStreak += 1
                } else {
                    longestStreak = max(longestStreak, tempStreak)
                    tempStreak = 1
                }
            } else {
                tempStreak = 1
            }
            previousDate = date
        }
        
        longestStreak = max(longestStreak, tempStreak)
        streakData.longestStreak = longestStreak
    }
    
    private func saveData() {
        if let practicesData = try? JSONEncoder().encode(practices) {
            UserDefaults.standard.set(practicesData, forKey: practicesKey)
        }
        
        if let historyData = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(historyData, forKey: historyKey)
        }
        
        if let streakData = try? JSONEncoder().encode(streakData) {
            UserDefaults.standard.set(streakData, forKey: streakKey)
        }
    }
    
    private func loadData() {
        if let practicesData = UserDefaults.standard.data(forKey: practicesKey),
           let decodedPractices = try? JSONDecoder().decode([Practice].self, from: practicesData) {
            practices = decodedPractices
        }
        
        if let historyData = UserDefaults.standard.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([HistoryEntry].self, from: historyData) {
            history = decodedHistory
        }
        
        if let streakData = UserDefaults.standard.data(forKey: streakKey),
           let decodedStreak = try? JSONDecoder().decode(StreakData.self, from: streakData) {
            self.streakData = decodedStreak
        }
        
        updateStreak()
    }
    
    func loadSampleData() {
        let calendar = Calendar.current
        practices = Practice.samplePractices
        
        var sampleHistory: [HistoryEntry] = []
        let samplePractices = Practice.samplePractices
        
        for dayOffset in 0..<14 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            guard let completedAt = calendar.date(bySettingHour: 20, minute: 30, second: 0, of: date) else { continue }
            
            let practice = samplePractices[dayOffset % samplePractices.count]
            let entry = HistoryEntry(
                practiceId: practice.id,
                practiceName: practice.name,
                practiceType: practice.type,
                duration: practice.duration,
                completedAt: completedAt,
                note: dayOffset % 3 == 0 ? "Felt good" : ""
            )
            sampleHistory.append(entry)
        }
        
        history = sampleHistory
        updateStreak()
        saveData()
    }
}
