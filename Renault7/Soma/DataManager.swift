import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var practices: [Practice] = []
    @Published var history: [HistoryEntry] = []
    @Published var todayEntry: HistoryEntry
    @Published var hasCompletedOnboarding: Bool = false
    
    private let practicesKey = "SavedPractices"
    private let historyKey = "SavedHistory"
    private let onboardingKey = "CompletedOnboarding"
    
    private init() {
        let today = Calendar.current.startOfDay(for: Date())
        self.todayEntry = HistoryEntry(date: today)
        
        loadData()
        createTodayEntryIfNeeded()
    }
    
    private static let encoder: JSONEncoder = JSONEncoder()
    private static let decoder: JSONDecoder = JSONDecoder()
    
    private func loadData() {
        if let practicesData = UserDefaults.standard.data(forKey: practicesKey),
           let decoded = try? DataManager.decoder.decode([Practice].self, from: practicesData) {
            self.practices = decoded
        }
        if let historyData = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? DataManager.decoder.decode([HistoryEntry].self, from: historyData) {
            self.history = decoded
        }
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    private func saveData() {
        if let practicesData = try? DataManager.encoder.encode(practices) {
            UserDefaults.standard.set(practicesData, forKey: practicesKey)
        }
        if let historyData = try? DataManager.encoder.encode(history) {
            UserDefaults.standard.set(historyData, forKey: historyKey)
        }
    }
    
    func persistNow() {
        saveData()
    }
    
    func saveDataIfNeeded() {
        saveData()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
    
    private func createTodayEntryIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let existingEntry = history.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            todayEntry = existingEntry
        } else {
            todayEntry = HistoryEntry(date: today)
            history.insert(todayEntry, at: 0)
        }
    }
    
    func updateWellnessState(_ type: WellnessType, level: Int) {
        todayEntry.wellnessStates[type] = level
        updateTodayEntryInMemory()
        calculateCareLevel()
    }
    
    func addPractice(_ practice: Practice) {
        practices.append(practice)
    }
    
    func deletePractice(_ practice: Practice) {
        practices.removeAll { $0.id == practice.id }
    }
    
    func completePractice(_ practice: Practice) {
        if let index = practices.firstIndex(where: { $0.id == practice.id }) {
            practices[index].lastCompleted = Date()
            practices[index].streak += 1
            todayEntry.completedPractices.append(practice.name)
            updateTodayEntryInMemory()
            calculateCareLevel()
        }
    }
    
    func completeChallenge(_ challenge: String) {
        todayEntry.completedChallenges.append(challenge)
        updateTodayEntryInMemory()
        calculateCareLevel()
    }
    
    private func updateTodayEntryInMemory() {
        if let index = history.firstIndex(where: { $0.id == todayEntry.id }) {
            history[index] = todayEntry
        }
    }
    
    private func calculateCareLevel() {
        var level: Double = 0
        if !todayEntry.wellnessStates.isEmpty { level += 0.3 }
        if !todayEntry.completedPractices.isEmpty { level += 0.4 }
        if !todayEntry.completedChallenges.isEmpty { level += 0.3 }
        todayEntry.careLevel = min(level, 1.0)
        updateTodayEntryInMemory()
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    func loadSampleData() {
        practices = SampleData.makePractices()
        history = SampleData.makeHistoryEntries(calendar: Calendar.current)
        createTodayEntryIfNeeded()
        saveData()
    }
}
