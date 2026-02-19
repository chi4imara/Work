import Foundation

class SampleDataGenerator {
    static let shared = SampleDataGenerator()
    
    private init() {}
    
    func generateSampleUser() -> User {
        return User(
            name: "Sarah Johnson",
            email: "sarah.johnson@example.com",
            goals: [.sleep, .activity, .water, .mindfulness],
            notificationsEnabled: true
        )
    }
    
    func generateSampleHabits() -> [Habit] {
        var habits = [
            Habit(name: "8 hours of sleep", type: .sleep, frequency: .daily, targetDays: 30),
            Habit(name: "Morning walk", type: .activity, frequency: .daily, targetDays: 21),
            Habit(name: "Drink 8 glasses of water", type: .water, frequency: .daily, targetDays: 14),
            Habit(name: "10 minutes meditation", type: .mindfulness, frequency: .daily, targetDays: 7),
            Habit(name: "Evening yoga", type: .activity, frequency: .weekly, targetDays: 12),
            Habit(name: "Read before bed", type: .mindfulness, frequency: .daily, targetDays: 20)
        ]
        
        habits[0].completedDays = 15
        habits[0].streak = 5
        habits[0].lastCompletedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        habits[1].completedDays = 8
        habits[1].streak = 3
        habits[1].lastCompletedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        habits[2].completedDays = 10
        habits[2].streak = 10
        habits[2].lastCompletedDate = Date()
        
        habits[3].completedDays = 4
        habits[3].streak = 4
        habits[3].lastCompletedDate = Date()
        
        habits[4].completedDays = 3
        habits[4].streak = 2
        habits[4].lastCompletedDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        
        habits[5].completedDays = 12
        habits[5].streak = 7
        habits[5].lastCompletedDate = Date()
        
        return habits
    }
    
    func generateSampleTasks() -> [TaskForBuild] {
        return [
            TaskForBuild(
                title: "Morning Stretch",
                description: "Start your day with gentle stretching exercises to wake up your body",
                type: .activity,
                duration: .short,
                goal: "Improve flexibility and energy"
            ),
            TaskForBuild(
                title: "Bedtime Routine",
                description: "Prepare for quality sleep with a relaxing evening routine",
                type: .sleep,
                duration: .medium,
                goal: "Better sleep quality"
            ),
            TaskForBuild(
                title: "Hydration Check",
                description: "Drink a glass of water to stay hydrated throughout the day",
                type: .water,
                duration: .short,
                goal: "Stay hydrated"
            ),
            TaskForBuild(
                title: "Breathing Exercise",
                description: "Practice deep breathing for 5 minutes to reduce stress",
                type: .mindfulness,
                duration: .short,
                goal: "Reduce stress and anxiety"
            ),
            TaskForBuild(
                title: "Evening Walk",
                description: "Take a relaxing 20-minute walk in the evening",
                type: .activity,
                duration: .medium,
                goal: "Daily movement and fresh air"
            ),
            TaskForBuild(
                title: "Gratitude Journal",
                description: "Write down 3 things you're grateful for today",
                type: .mindfulness,
                duration: .short,
                goal: "Positive mindset"
            ),
            TaskForBuild(
                title: "Water Intake Tracking",
                description: "Track your water consumption for the day",
                type: .water,
                duration: .short,
                goal: "Maintain hydration"
            ),
            TaskForBuild(
                title: "Sleep Preparation",
                description: "Create a calm environment for better sleep",
                type: .sleep,
                duration: .short,
                goal: "Quality rest"
            ),
            TaskForBuild(
                title: "Mindful Meditation",
                description: "Practice mindfulness meditation for inner peace",
                type: .mindfulness,
                duration: .medium,
                goal: "Mental clarity"
            ),
            TaskForBuild(
                title: "Active Break",
                description: "Take a 10-minute active break from work",
                type: .activity,
                duration: .short,
                goal: "Stay active"
            )
        ]
    }
    
    func generateSampleAchievements() -> [Achievement] {
        var achievements = [
            Achievement(title: "Sleep Champion", description: "7 days of regular sleep", type: .sleep, requiredDays: 7),
            Achievement(title: "Active Lifestyle", description: "5 days of activity", type: .activity, requiredDays: 5),
            Achievement(title: "Hydration Hero", description: "10 days of proper hydration", type: .water, requiredDays: 10),
            Achievement(title: "Mindful Master", description: "7 days of mindfulness", type: .mindfulness, requiredDays: 7),
            Achievement(title: "Sleep Warrior", description: "14 days of consistent sleep", type: .sleep, requiredDays: 14),
            Achievement(title: "Fitness Enthusiast", description: "10 days of activity", type: .activity, requiredDays: 10),
            Achievement(title: "Water Wizard", description: "20 days of hydration", type: .water, requiredDays: 20),
            Achievement(title: "Zen Master", description: "14 days of mindfulness", type: .mindfulness, requiredDays: 14)
        ]
        
        achievements[2].unlock()
        achievements[3].unlock()
        
        return achievements
    }
    
    func loadSampleData(into appViewModel: AppViewModel) {
        appViewModel.user = generateSampleUser()
        
        appViewModel.habits = generateSampleHabits()
        
        appViewModel.tasks = generateSampleTasks()
        
        appViewModel.achievements = generateSampleAchievements()
        
        appViewModel.checkAndUnlockAchievements()
        
        DataManager.shared.saveUser(appViewModel.user)
        DataManager.shared.saveHabits(appViewModel.habits)
        DataManager.shared.saveTasks(appViewModel.tasks)
        DataManager.shared.saveAchievements(appViewModel.achievements)
    }
    
    func clearAllData(from appViewModel: AppViewModel) {
        appViewModel.user = User()
        appViewModel.habits = []
        appViewModel.tasks = []
        appViewModel.achievements = []
        
        DataManager.shared.clearAllData()
    }
}
