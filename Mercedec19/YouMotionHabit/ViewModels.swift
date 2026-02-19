import Foundation
import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var isLoading = true
    @Published var selectedTab = 0
    @Published var showOnboarding = false
    
    init() {
        checkFirstLaunch()
        simulateLoading()
    }
    
    private func checkFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            isFirstLaunch = false
        } else {
            showOnboarding = true
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    private func simulateLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading = false
        }
    }
}

class UserProfileViewModel: ObservableObject {
    @Published var profile = UserProfile()
    
    private let userDefaultsKey = "UserProfile"
    
    init() {
        loadProfile()
    }
    
    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            profile = decoded
        }
    }
    
    func updateProfile(name: String, email: String, level: FitnessLevel, goals: [FitnessGoal], workouts: [WorkoutType]) {
        profile.name = name
        profile.email = email
        profile.fitnessLevel = level
        profile.goals = goals
        profile.preferredWorkouts = workouts
        saveProfile()
    }
    
    func loadSampleData(profile: UserProfile) {
        self.profile = profile
        saveProfile()
    }
}

class WorkoutsViewModel: ObservableObject {
    @Published var availableWorkouts: [Workout] = []
    @Published var scheduledWorkouts: [ScheduledWorkout] = []
    @Published var filteredWorkouts: [Workout] = []
    
    @Published var selectedGoal: FitnessGoal?
    @Published var selectedLevel: FitnessLevel?
    @Published var selectedType: WorkoutType?
    @Published var selectedDuration: Int?
    
    private let scheduledWorkoutsKey = "ScheduledWorkouts"
    private let availableWorkoutsKey = "AvailableWorkouts"
    
    init() {
        loadWorkouts()
        loadScheduledWorkouts()
        applyFilters()
    }
    
    private func loadWorkouts() {
        if let data = UserDefaults.standard.data(forKey: availableWorkoutsKey),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            availableWorkouts = decoded
        } else {
            availableWorkouts = []
        }
        applyFilters()
    }
    
    private func saveAvailableWorkouts() {
        if let encoded = try? JSONEncoder().encode(availableWorkouts) {
            UserDefaults.standard.set(encoded, forKey: availableWorkoutsKey)
        }
    }
    
    func addWorkoutTemplate(_ workout: Workout) {
        availableWorkouts.append(workout)
        saveAvailableWorkouts()
        applyFilters()
    }
    
    func removeWorkoutTemplate(_ workout: Workout) {
        availableWorkouts.removeAll { $0.id == workout.id }
        saveAvailableWorkouts()
        applyFilters()
    }
    
    private func loadScheduledWorkouts() {
        if let data = UserDefaults.standard.data(forKey: scheduledWorkoutsKey),
           let decoded = try? JSONDecoder().decode([ScheduledWorkout].self, from: data) {
            scheduledWorkouts = decoded
        }
    }
    
    private func saveScheduledWorkouts() {
        if let encoded = try? JSONEncoder().encode(scheduledWorkouts) {
            UserDefaults.standard.set(encoded, forKey: scheduledWorkoutsKey)
        }
    }
    
    func applyFilters() {
        filteredWorkouts = availableWorkouts.filter { workout in
            var matches = true
            
            if let goal = selectedGoal {
                matches = matches && workout.goal == goal
            }
            
            if let level = selectedLevel {
                matches = matches && workout.difficulty == level
            }
            
            if let type = selectedType {
                matches = matches && workout.type == type
            }
            
            if let duration = selectedDuration {
                matches = matches && workout.duration <= duration
            }
            
            return matches
        }
    }
    
    func clearFilters() {
        selectedGoal = nil
        selectedLevel = nil
        selectedType = nil
        selectedDuration = nil
        applyFilters()
    }
    
    func scheduleWorkout(_ workout: Workout, for date: Date) {
        let scheduled = ScheduledWorkout(workout: workout, scheduledDate: date)
        scheduledWorkouts.append(scheduled)
        saveScheduledWorkouts()
    }
    
    func completeWorkout(_ scheduledWorkout: ScheduledWorkout) {
        if let index = scheduledWorkouts.firstIndex(where: { $0.id == scheduledWorkout.id }) {
            scheduledWorkouts[index].status = .completed
            scheduledWorkouts[index].completedDate = Date()
            saveScheduledWorkouts()
        }
    }
    
    func cancelWorkout(_ scheduledWorkout: ScheduledWorkout) {
        if let index = scheduledWorkouts.firstIndex(where: { $0.id == scheduledWorkout.id }) {
            scheduledWorkouts[index].status = .missed
            saveScheduledWorkouts()
        }
    }
    
    func addNote(to scheduledWorkout: ScheduledWorkout, note: String) {
        if let index = scheduledWorkouts.firstIndex(where: { $0.id == scheduledWorkout.id }) {
            scheduledWorkouts[index].notes = note
            saveScheduledWorkouts()
        }
    }
    
    func loadSampleData(workouts: [Workout], scheduled: [ScheduledWorkout]) {
        availableWorkouts = workouts
        scheduledWorkouts = scheduled
        clearFilters()
        applyFilters()
        saveAvailableWorkouts()
        saveScheduledWorkouts()
    }
}

class ProgressViewModel: ObservableObject {
    @Published var progressData = ProgressData()
    @Published var selectedEnergyLevel = 3
    
    private let progressDataKey = "ProgressData"
    
    init() {
        loadProgressData()
    }
    
    private func loadProgressData() {
        if let data = UserDefaults.standard.data(forKey: progressDataKey),
           let decoded = try? JSONDecoder().decode(ProgressData.self, from: data) {
            progressData = decoded
        }
    }
    
    private func saveProgressData() {
        if let encoded = try? JSONEncoder().encode(progressData) {
            UserDefaults.standard.set(encoded, forKey: progressDataKey)
        }
    }
    
    func recordWorkout() {
        let today = Calendar.current.startOfDay(for: Date())
        progressData.totalWorkouts += 1
        progressData.weeklyWorkouts[today, default: 0] += 1
        
        updateStreak()
        
        checkAchievements()
        
        saveProgressData()
    }
    
    func recordEnergyLevel(_ level: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        progressData.energyLevels[today] = level
        saveProgressData()
    }
    
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
           progressData.weeklyWorkouts[yesterday] ?? 0 > 0 {
            progressData.currentStreak += 1
        } else if progressData.weeklyWorkouts[today] ?? 0 == 1 {
            progressData.currentStreak = 1
        }
        
        if progressData.currentStreak > progressData.longestStreak {
            progressData.longestStreak = progressData.currentStreak
        }
    }
    
    private func checkAchievements() {
        if progressData.totalWorkouts == 1 {
            unlockAchievement(title: "First Steps")
        }
        
        if progressData.currentStreak >= 5 {
            unlockAchievement(title: "Consistency Champion")
        }
        
        let thisWeek = getThisWeekWorkouts()
        if thisWeek >= 7 {
            unlockAchievement(title: "Week Warrior")
        }
    }
    
    private func unlockAchievement(title: String) {
        if let index = progressData.achievements.firstIndex(where: { $0.title == title && !$0.isUnlocked }) {
            progressData.achievements[index].isUnlocked = true
            progressData.achievements[index].unlockedDate = Date()
        }
    }
    
    private func getThisWeekWorkouts() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        var count = 0
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: weekStart) {
                let dayStart = calendar.startOfDay(for: day)
                count += progressData.weeklyWorkouts[dayStart] ?? 0
            }
        }
        return count
    }
    
    func getWeeklyProgress() -> [Int] {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        var weekData: [Int] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: weekStart) {
                let dayStart = calendar.startOfDay(for: day)
                weekData.append(progressData.weeklyWorkouts[dayStart] ?? 0)
            } else {
                weekData.append(0)
            }
        }
        return weekData
    }
    
    func loadSampleData(progressData: ProgressData) {
        self.progressData = progressData
        saveProgressData()
    }
}
