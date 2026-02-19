import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var hasCompletedOnboarding: Bool = false
    @Published var showSplashScreen: Bool = true
    
    init() {
        self.currentUser = User()
        loadUserData()
    }
    
    func completeSplashScreen() {
        showSplashScreen = false
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveUserData()
    }
    
    private func loadUserData() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    private func saveUserData() {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
    }
}

class TodayViewModel: ObservableObject {
    @Published var todayProgress: DailyProgress
    @Published var dailyChallenge: Challenge
    @Published var greeting: String = ""
    
    init() {
        let calendar = Calendar.current
        let today = Date()
        let saved = PersistenceManager.load()
        if let progress = saved?.todayProgress,
           calendar.isDate(progress.date, inSameDayAs: today) {
            self.todayProgress = progress
        } else {
            self.todayProgress = DailyProgress()
        }
        if let challenge = saved?.dailyChallenge {
            self.dailyChallenge = challenge
        } else {
            self.dailyChallenge = Challenge.sampleChallenges.randomElement() ?? Challenge.sampleChallenges[0]
        }
        updateGreeting()
    }
    
    func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            greeting = "Good morning"
        case 12..<17:
            greeting = "Good afternoon"
        case 17..<22:
            greeting = "Good evening"
        default:
            greeting = "Good night"
        }
    }
    
    func addSleepEntry(bedtime: Date, wakeTime: Date, quality: Int) {
        let sleepEntry = SleepEntry(bedtime: bedtime, wakeTime: wakeTime, quality: quality)
        todayProgress.sleepEntry = sleepEntry
    }

    func addMealEntry(type: MealType, name: String, healthRating: Int) {
        let meal = MealEntry(type: type, name: name, healthRating: healthRating)
        todayProgress.mealEntries.append(meal)
    }

    func addActivityEntry(type: ActivityType, name: String, duration: TimeInterval) {
        let activity = ActivityEntry(type: type, name: name, duration: duration)
        todayProgress.activityEntries.append(activity)
    }

    func completeActivity(id: UUID) {
        if let index = todayProgress.activityEntries.firstIndex(where: { $0.id == id }) {
            todayProgress.activityEntries[index].isCompleted = true
        }
    }

    func completeDailyChallenge() {
        dailyChallenge.isCompleted = true
        if !todayProgress.completedChallenges.contains(dailyChallenge.id) {
            todayProgress.completedChallenges.append(dailyChallenge.id)
        }
    }

    func updateMoodAndEnergy(mood: Int, energy: Int) {
        todayProgress.moodRating = mood
        todayProgress.energyLevel = energy
    }

    func loadSampleData() {
        todayProgress = SampleData.makeTodayProgress()
        dailyChallenge = SampleData.makeDailyChallenge()
    }
}

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var selectedCategory: HabitCategory?
    
    init() {
        if let saved = PersistenceManager.load(), !saved.habits.isEmpty {
            habits = saved.habits
        } else {
            loadSampleHabits()
        }
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }

    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
    }

    func deleteHabit(id: UUID) {
        habits.removeAll { $0.id == id }
    }

    func toggleHabitCompletion(id: UUID, date: Date = Date()) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            let calendar = Calendar.current
            let targetDate = calendar.startOfDay(for: date)
            
            if let existingIndex = habits[index].completedDates.firstIndex(where: { 
                calendar.isDate($0, inSameDayAs: targetDate) 
            }) {
                habits[index].completedDates.remove(at: existingIndex)
            } else {
                habits[index].completedDates.append(targetDate)
            }
        }
    }
    
    func isHabitCompletedToday(id: UUID) -> Bool {
        guard let habit = habits.first(where: { $0.id == id }) else { return false }
        let today = Calendar.current.startOfDay(for: Date())
        return habit.completedDates.contains { Calendar.current.isDate($0, inSameDayAs: today) }
    }
    
    func habit(by id: UUID) -> Habit? {
        habits.first { $0.id == id }
    }
    
    var filteredHabits: [Habit] {
        if let category = selectedCategory {
            return habits.filter { $0.category == category && $0.isActive }
        }
        return habits.filter { $0.isActive }
    }
    
    func refresh() {
        if Thread.isMainThread {
            objectWillChange.send()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.objectWillChange.send()
            }
        }
    }
    
    func loadSampleData() {
        habits = SampleData.makeHabits()
    }
    
    private func loadSampleHabits() {
        habits = [
            Habit(name: "Morning meditation", category: .mindfulness, icon: "brain.head.profile"),
            Habit(name: "Drink 8 glasses of water", category: .nutrition, icon: "drop"),
            Habit(name: "30 min walk", category: .activity, icon: "figure.walk"),
            Habit(name: "Read before bed", category: .selfCare, icon: "book"),
            Habit(name: "Sleep 8 hours", category: .sleep, icon: "bed.double")
        ]
    }
}

class HistoryViewModel: ObservableObject {
    @Published var dailyProgressHistory: [DailyProgress] = []
    @Published var selectedDate: Date = Date()
    @Published var selectedMonth: Date = Date()
    
    init() {
        if let saved = PersistenceManager.load(), !saved.dailyProgressHistory.isEmpty {
            dailyProgressHistory = saved.dailyProgressHistory
        }
    }
    
    func getProgressForDate(_ date: Date) -> DailyProgress? {
        let calendar = Calendar.current
        return dailyProgressHistory.first { progress in
            calendar.isDate(progress.date, inSameDayAs: date)
        }
    }
    
    func addOrUpdateProgress(_ progress: DailyProgress) {
        let apply: () -> Void = { [weak self] in
            guard let self = self else { return }
            let calendar = Calendar.current
            var updated = self.dailyProgressHistory
            if let index = updated.firstIndex(where: {
                calendar.isDate($0.date, inSameDayAs: progress.date)
            }) {
                updated[index] = progress
            } else {
                updated.insert(progress, at: 0)
            }
            self.dailyProgressHistory = updated
        }
        if Thread.isMainThread {
            apply()
        } else {
            DispatchQueue.main.async(execute: apply)
        }
    }
    
    func getCompletionPercentageForDate(_ date: Date) -> Double {
        guard !dailyProgressHistory.isEmpty else { return 0.0 }
        return getProgressForDate(date)?.completionPercentage ?? 0.0
    }
    
    func refresh() {
        if Thread.isMainThread {
            objectWillChange.send()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.objectWillChange.send()
            }
        }
    }
    
    func loadSampleData() {
        if Thread.isMainThread {
            dailyProgressHistory = SampleData.makeFullHistory()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.dailyProgressHistory = SampleData.makeFullHistory()
            }
        }
    }
    
    func getStreakCount() -> Int {
        guard !dailyProgressHistory.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedProgress = dailyProgressHistory
            .sorted { $0.date > $1.date }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for progress in sortedProgress {
            if calendar.isDate(progress.date, inSameDayAs: currentDate) && progress.completionPercentage > 0.5 {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
}
