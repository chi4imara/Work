import Foundation
import Combine

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var achievements: [Achievement] = []
    
    private let userDefaults = UserDefaults.standard
    private let habitsKey = "SavedHabits"
    private let achievementsKey = "SavedAchievements"
    
    init() {
        loadHabits()
        loadAchievements()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
            
            if habit.shouldBeInTrophies && !habit.isInTrophies {
                addToTrophies(habit)
            }
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        achievements.removeAll { $0.habitId == habit.id }
        saveHabits()
        saveAchievements()
    }
    
    func checkHabitToday(_ habitId: UUID) {
        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            habits[index].checkToday()
            saveHabits()
            
            checkForNewAchievements(habit: habits[index])
        }
    }
    
    func resetHabitStreak(_ habitId: UUID) {
        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            habits[index].resetStreak()
            saveHabits()
        }
    }
    
    func addToTrophies(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isInTrophies = true
            saveHabits()
        }
    }
    
    func removeFromTrophies(_ habitId: UUID) {
        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            habits[index].isInTrophies = false
            saveHabits()
        }
    }
    
    var activeHabits: [Habit] {
        habits.filter { $0.currentStreak >= 0 }
    }
    
    var trophyHabits: [Habit] {
        habits.filter { $0.isInTrophies }
    }
    
    func habitsForCategory(_ category: HabitCategory) -> [Habit] {
        habits.filter { $0.category == category }
    }
    
    private func checkForNewAchievements(habit: Habit) {
        let milestones = [7, 14, 30, 60, 100, 365]
        
        for milestone in milestones {
            if habit.currentStreak == milestone {
                let achievement = Achievement(
                    habitId: habit.id,
                    milestone: milestone,
                    achievedDate: Date(),
                    habitName: habit.name,
                    habitCategory: habit.category
                )
                achievements.append(achievement)
                saveAchievements()
                break
            }
        }
    }
    
    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            userDefaults.set(encoded, forKey: habitsKey)
        }
    }
    
    private func loadHabits() {
        if let data = userDefaults.data(forKey: habitsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            userDefaults.set(encoded, forKey: achievementsKey)
        }
    }
    
    private func loadAchievements() {
        if let data = userDefaults.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }
    }
}
