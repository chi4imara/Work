import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var user: User = User() {
        didSet {
            DataManager.shared.saveUser(user)
        }
    }
    @Published var habits: [Habit] = [] {
        didSet {
            DataManager.shared.saveHabits(habits)
        }
    }
    @Published var tasks: [TaskForBuild] = [] {
        didSet {
            DataManager.shared.saveTasks(tasks)
        }
    }
    @Published var achievements: [Achievement] = [] {
        didSet {
            DataManager.shared.saveAchievements(achievements)
        }
    }
    @Published var selectedTab: Int = 0
    
    init() {
        loadData()
    }
    
    private func loadData() {
        if let savedUser = DataManager.shared.loadUser() {
            user = savedUser
        }
        
        habits = DataManager.shared.loadHabits()
        
        tasks = DataManager.shared.loadTasks()
        
        achievements = DataManager.shared.loadAchievements()
        
        if achievements.isEmpty {
            initializeDefaultAchievements()
        }
    }
    
    private func initializeDefaultAchievements() {
        achievements = [
            Achievement(title: "Sleep Champion", description: "7 days of regular sleep", type: .sleep, requiredDays: 7),
            Achievement(title: "Active Lifestyle", description: "5 days of activity", type: .activity, requiredDays: 5),
            Achievement(title: "Hydration Hero", description: "10 days of proper hydration", type: .water, requiredDays: 10),
            Achievement(title: "Mindful Master", description: "7 days of mindfulness", type: .mindfulness, requiredDays: 7)
        ]
        DataManager.shared.saveAchievements(achievements)
    }
    
    func addTask(_ task: TaskForBuild) {
        tasks.append(task)
    }
    
    func updateTask(_ task: TaskForBuild) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskForBuild) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
    }
    
    func checkAndUnlockAchievements() {
        for habit in habits {
            for i in 0..<achievements.count {
                if achievements[i].type == habit.type &&
                   !achievements[i].isUnlocked &&
                   habit.completedDays >= achievements[i].requiredDays {
                    achievements[i].unlock()
                }
            }
        }
    }
    
    func loadSampleData() {
        SampleDataGenerator.shared.loadSampleData(into: self)
    }
    
    func clearAllData() {
        SampleDataGenerator.shared.clearAllData(from: self)
    }
}

class TasksViewModel: ObservableObject {
    @Published var tasks: [TaskForBuild] = []
    @Published var filter = TaskFilter()
    @Published var showingFilters = false
    @Published var showingAddTask = false
    
    var filteredTasks: [TaskForBuild] {
        var filtered = tasks
        
        if !filter.selectedTypes.isEmpty {
            filtered = filtered.filter { filter.selectedTypes.contains($0.type) }
        }
        
        if !filter.selectedDurations.isEmpty {
            filtered = filtered.filter { filter.selectedDurations.contains($0.duration) }
        }
        
        if !filter.searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(filter.searchText) ||
                $0.description.localizedCaseInsensitiveContains(filter.searchText)
            }
        }
        
        return filtered
    }
    
    func completeTask(_ task: TaskForBuild) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].markCompleted()
        }
    }
    
    func addTask(_ task: TaskForBuild) {
        tasks.append(task)
    }
    
    func deleteTask(_ task: TaskForBuild) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func resetFilters() {
        filter.reset()
    }
}

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var showingAddHabit = false
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
    }
    
    func updateHabitProgress(_ habitId: UUID) {
        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            habits[index].completedDays += 1
            habits[index].streak += 1
            habits[index].lastCompletedDate = Date()
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
    }
}

class ProgressViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var achievements: [Achievement] = []
    @Published var selectedTimeFrame: TimeFrame = .week
    
    enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var progressData: [ProgressData] {
        let calendar = Calendar.current
        let now = Date()
        var data: [ProgressData] = []
        
        let daysToShow: Int
        switch selectedTimeFrame {
        case .week: daysToShow = 7
        case .month: daysToShow = 30
        case .year: daysToShow = 365
        }
        
        for i in 0..<daysToShow {
            let date = calendar.date(byAdding: .day, value: -i, to: now) ?? now
            
            for habit in habits {
                let progress = Double.random(in: 0...1) 
                data.append(ProgressData(date: date, value: progress, type: habit.type))
            }
        }
        
        return data.sorted { $0.date < $1.date }
    }
    
    var completionRate: Double {
        let totalHabits = habits.count
        guard totalHabits > 0 else { return 0 }
        
        let completedToday = habits.filter { habit in
            guard let lastCompleted = habit.lastCompletedDate else { return false }
            return Calendar.current.isDateInToday(lastCompleted)
        }.count
        
        return Double(completedToday) / Double(totalHabits)
    }
    
    var streakData: [(HabitType, Int)] {
        habits.map { ($0.type, $0.streak) }
    }
}

enum ReminderSlot {
    case morning
    case evening
}

class ProfileViewModel: ObservableObject {
    @Published var user: User = User() {
        didSet {
            DataManager.shared.saveUser(user)
        }
    }
    @Published var isEditing = false
    @Published var showingImagePicker = false
    @Published var showingTimePicker = false
    @Published var editingReminderSlot: ReminderSlot = .morning
    
    func saveProfile() {
        DataManager.shared.saveUser(user)
        isEditing = false
    }
    
    func updateNotificationSettings(_ enabled: Bool) {
        user.notificationsEnabled = enabled
        DataManager.shared.saveUser(user)
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showingRateApp = false
    
    func rateApp() {
        showingRateApp = true
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/31d4dee1-e9a3-4c42-9528-991286d96f60") {
            UIApplication.shared.open(url)
        }
    }
    
    func contactUs() {
        if let url = URL(string: "https://www.termsfeed.com/live/31d4dee1-e9a3-4c42-9528-991286d96f60") {
            UIApplication.shared.open(url)
        }
    }
}
