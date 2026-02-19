import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let user = "saved_user"
        static let habits = "saved_habits"
        static let tasks = "saved_tasks"
        static let achievements = "saved_achievements"
    }
    
    private init() {}
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: Keys.user)
        }
    }
    
    func loadUser() -> User? {
        guard let data = userDefaults.data(forKey: Keys.user),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func saveHabits(_ habits: [Habit]) {
        if let encoded = try? JSONEncoder().encode(habits) {
            userDefaults.set(encoded, forKey: Keys.habits)
        }
    }
    
    func loadHabits() -> [Habit] {
        guard let data = userDefaults.data(forKey: Keys.habits),
              let habits = try? JSONDecoder().decode([Habit].self, from: data) else {
            return []
        }
        return habits
    }
    
    func saveTasks(_ tasks: [TaskForBuild]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            userDefaults.set(encoded, forKey: Keys.tasks)
        }
    }
    
    func loadTasks() -> [TaskForBuild] {
        guard let data = userDefaults.data(forKey: Keys.tasks),
              let tasks = try? JSONDecoder().decode([TaskForBuild].self, from: data) else {
            return []
        }
        return tasks
    }
    
    func saveAchievements(_ achievements: [Achievement]) {
        if let encoded = try? JSONEncoder().encode(achievements) {
            userDefaults.set(encoded, forKey: Keys.achievements)
        }
    }
    
    func loadAchievements() -> [Achievement] {
        guard let data = userDefaults.data(forKey: Keys.achievements),
              let achievements = try? JSONDecoder().decode([Achievement].self, from: data) else {
            return []
        }
        return achievements
    }
    
    func clearAllData() {
        userDefaults.removeObject(forKey: Keys.user)
        userDefaults.removeObject(forKey: Keys.habits)
        userDefaults.removeObject(forKey: Keys.tasks)
        userDefaults.removeObject(forKey: Keys.achievements)
    }
}
