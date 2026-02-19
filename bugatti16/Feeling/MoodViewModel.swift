import Foundation
import SwiftUI
import Combine

class MoodViewModel: ObservableObject {
    @Published var dailyEntries: [DailyEntry] = []
    @Published var rituals: [Ritual] = []
    @Published var userProgress: UserProgress = UserProgress()
    @Published var currentDailyChallenge: DailyChallenge = DailyChallenge.challenges.randomElement() ?? DailyChallenge.challenges[0]
    @Published var hasCompletedOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "DailyEntries"
    private let ritualsKey = "Rituals"
    private let progressKey = "UserProgress"
    private let onboardingKey = "HasCompletedOnboarding"
    
    init() {
        loadData()
        setupDefaultRituals()
    }
    
    private func loadData() {
        loadDailyEntries()
        loadRituals()
        loadUserProgress()
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
    }
    
    private func loadDailyEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let entries = try? JSONDecoder().decode([DailyEntry].self, from: data) {
            dailyEntries = entries
        }
    }
    
    private func loadRituals() {
        if let data = userDefaults.data(forKey: ritualsKey),
           let savedRituals = try? JSONDecoder().decode([Ritual].self, from: data) {
            rituals = savedRituals
        }
    }
    
    private func loadUserProgress() {
        if let data = userDefaults.data(forKey: progressKey),
           let progress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            userProgress = progress
        }
    }
    
    private func saveData() {
        saveDailyEntries()
        saveRituals()
        saveUserProgress()
    }
    
    private func saveDailyEntries() {
        if let data = try? JSONEncoder().encode(dailyEntries) {
            userDefaults.set(data, forKey: entriesKey)
        }
    }
    
    private func saveRituals() {
        if let data = try? JSONEncoder().encode(rituals) {
            userDefaults.set(data, forKey: ritualsKey)
        }
    }
    
    private func saveUserProgress() {
        if let data = try? JSONEncoder().encode(userProgress) {
            userDefaults.set(data, forKey: progressKey)
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func getTodayEntry() -> DailyEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) })
    }
    
    func ensureTodayEntry() {
        let today = Calendar.current.startOfDay(for: Date())
        guard !dailyEntries.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) else { return }
        dailyEntries.append(DailyEntry(date: today))
        saveData()
    }
    
    func updateTodayMood(_ mood: Mood, note: String = "") {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = dailyEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyEntries[index].selectedMood = mood
            dailyEntries[index].note = note
        } else {
            var newEntry = DailyEntry(date: today)
            newEntry.selectedMood = mood
            newEntry.note = note
            dailyEntries.append(newEntry)
        }
        
        updateTodayProgress()
        saveData()
    }
    
    func setupDefaultRituals() {
        if rituals.isEmpty {
            rituals = [
                Ritual(name: "Morning Meditation", category: .meditation, frequency: .daily, description: "5 minutes of mindful breathing", createdDate: Date()),
                Ritual(name: "Gratitude Journal", category: .gratitude, frequency: .daily, description: "Write 3 things you're grateful for", createdDate: Date()),
                Ritual(name: "Deep Breathing", category: .breathing, frequency: .daily, description: "Practice 4-7-8 breathing technique", createdDate: Date()),
                Ritual(name: "Evening Reflection", category: .journaling, frequency: .daily, description: "Reflect on your day", createdDate: Date())
            ]
            saveData()
        }
    }
    
    func addRitual(_ ritual: Ritual) {
        rituals.append(ritual)
        saveData()
    }
    
    func updateRitual(_ ritual: Ritual) {
        if let index = rituals.firstIndex(where: { $0.id == ritual.id }) {
            rituals[index] = ritual
            saveData()
        }
    }
    
    func deleteRitual(_ ritual: Ritual) {
        rituals.removeAll { $0.id == ritual.id }
        saveData()
    }
    
    func toggleRitualCompletion(_ ritual: Ritual) {
        if let index = rituals.firstIndex(where: { $0.id == ritual.id }) {
            rituals[index].isCompleted.toggle()
            
            if rituals[index].isCompleted {
                rituals[index].completionDates.append(Date())
                rituals[index].streak += 1
                userProgress.completedRituals += 1
                
                let today = Calendar.current.startOfDay(for: Date())
                if let entryIndex = dailyEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
                    dailyEntries[entryIndex].completedRituals.append(ritual.id)
                } else {
                    var newEntry = DailyEntry(date: today)
                    newEntry.completedRituals.append(ritual.id)
                    dailyEntries.append(newEntry)
                }
            } else {
                rituals[index].streak = max(0, rituals[index].streak - 1)
                userProgress.completedRituals = max(0, userProgress.completedRituals - 1)
                
                let today = Calendar.current.startOfDay(for: Date())
                if let entryIndex = dailyEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
                    dailyEntries[entryIndex].completedRituals.removeAll { $0 == ritual.id }
                }
            }
            
            updateTodayProgress()
            saveData()
        }
    }
    
    func completeDailyChallenge() {
        currentDailyChallenge.isCompleted = true
        userProgress.completedChallenges += 1
        
        let today = Calendar.current.startOfDay(for: Date())
        if let index = dailyEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyEntries[index].completedChallenge = currentDailyChallenge
        } else {
            var newEntry = DailyEntry(date: today)
            newEntry.completedChallenge = currentDailyChallenge
            dailyEntries.append(newEntry)
        }
        
        updateTodayProgress()
        saveData()
    }
    
    private func updateTodayProgress() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = dailyEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            var progress: Double = 0
            let totalTasks: Double = 3
            
            if dailyEntries[index].selectedMood != nil {
                progress += 1
            }
            
            let completedRituals = rituals.filter { $0.isCompleted }.count
            if completedRituals > 0 {
                progress += 1
            }
            
            if currentDailyChallenge.isCompleted {
                progress += 1
            }
            
            dailyEntries[index].progressPercentage = progress / totalTasks
        }
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    
    func getTodayProgressPercentage() -> Double {
        return getTodayEntry()?.progressPercentage ?? 0
    }
    
    func getCompletedRitualsToday() -> [Ritual] {
        return rituals.filter { $0.isCompleted }
    }
    
    func getMoodHistory(for days: Int = 7) -> [DailyEntry] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -days, to: endDate) ?? endDate
        
        return dailyEntries.filter { entry in
            entry.date >= startDate && entry.date <= endDate
        }.sorted { $0.date < $1.date }
    }
    
    func loadSampleData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let sampleRituals: [Ritual] = [
            Ritual(name: "Morning Meditation", category: .meditation, frequency: .daily, description: "5 minutes of mindful breathing", createdDate: today),
            Ritual(name: "Gratitude Journal", category: .gratitude, frequency: .daily, description: "Write 3 things you're grateful for", createdDate: today),
            Ritual(name: "Deep Breathing", category: .breathing, frequency: .daily, description: "Practice 4-7-8 breathing technique", createdDate: today),
            Ritual(name: "Evening Reflection", category: .journaling, frequency: .daily, description: "Reflect on your day", createdDate: today),
            Ritual(name: "Quick Stretch", category: .exercise, frequency: .daily, description: "10 minutes of gentle stretching", createdDate: today)
        ]
        rituals = sampleRituals
        let ritualIds = rituals.map { $0.id }
        
        let moodTypes = Mood.EmotionType.allCases
        var entries: [DailyEntry] = []
        var totalRitualCompletions = 0
        var totalChallenges = 0
        
        for dayOffset in (0..<14).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            
            let moodIndex = dayOffset % moodTypes.count
            let mood = Mood(emotion: moodTypes[moodIndex], note: dayOffset % 3 == 0 ? "Sample note for this day" : "", date: dayStart, photoData: nil)
            
            let completedRitualCount = min(dayOffset % 4, ritualIds.count)
            let completedRitualIds = Array(ritualIds.prefix(max(1, completedRitualCount)))
            totalRitualCompletions += completedRitualIds.count
            
            var challenge: DailyChallenge?
            if dayOffset % 2 == 0 {
                let template = DailyChallenge.challenges[dayOffset % DailyChallenge.challenges.count]
                var dc = DailyChallenge(title: template.title, description: template.description, category: template.category)
                dc.isCompleted = true
                dc.date = dayStart
                challenge = dc
                totalChallenges += 1
            }
            
            let progress: Double = {
                var p = 0.0
                if true { p += 1.0 }
                if !completedRitualIds.isEmpty { p += 1.0 }
                if challenge != nil { p += 1.0 }
                return p / 3.0
            }()
            
            var entry = DailyEntry(date: dayStart)
            entry.selectedMood = mood
            entry.note = mood.note
            entry.completedRituals = completedRitualIds
            entry.completedChallenge = challenge
            entry.progressPercentage = progress
            entries.append(entry)
        }
        
        dailyEntries = entries
        
        for i in rituals.indices {
            let rid = rituals[i].id
            let dates = dailyEntries
                .filter { $0.completedRituals.contains(rid) }
                .map { calendar.startOfDay(for: $0.date) }
                .sorted()
            rituals[i].completionDates = dates
            rituals[i].streak = consecutiveStreak(calendar: calendar, dates: dates, from: today)
            rituals[i].isCompleted = dates.contains(today)
        }
        
        userProgress.totalDays = dailyEntries.count
        userProgress.completedRituals = rituals.reduce(0) { $0 + $1.completionDates.count }
        userProgress.completedChallenges = totalChallenges
        userProgress.currentStreak = consecutiveDaysWithActivity(calendar: calendar, entries: dailyEntries, from: today)
        userProgress.longestStreak = max(userProgress.longestStreak, userProgress.currentStreak)
        
        currentDailyChallenge = DailyChallenge.challenges.randomElement() ?? DailyChallenge.challenges[0]
        saveData()
    }
    
    private func consecutiveStreak(calendar: Calendar, dates: [Date], from reference: Date) -> Int {
        var streak = 0
        var check = calendar.startOfDay(for: reference)
        let sorted = dates.sorted(by: >)
        for d in sorted {
            if calendar.isDate(d, inSameDayAs: check) {
                streak += 1
                guard let next = calendar.date(byAdding: .day, value: -1, to: check) else { break }
                check = next
            } else if d < check { break }
        }
        return streak
    }
    
    private func consecutiveDaysWithActivity(calendar: Calendar, entries: [DailyEntry], from reference: Date) -> Int {
        let withActivity = entries.filter { e in
            e.selectedMood != nil || !e.completedRituals.isEmpty || e.completedChallenge != nil
        }.map { calendar.startOfDay(for: $0.date) }
        return consecutiveStreak(calendar: calendar, dates: withActivity, from: reference)
    }
}
