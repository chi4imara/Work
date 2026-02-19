import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let coursesKey = "savedCourses"
    private let skillsKey = "savedSkills"
    private let progressKey = "savedProgress"
    private let achievementsKey = "savedAchievements"
    private let dailyActivityKey = "savedDailyActivity"
    private let userKey = "savedUser"
    
    private init() {}
    
    func saveCourses(_ courses: [Course]) {
        if let encoded = try? JSONEncoder().encode(courses) {
            UserDefaults.standard.set(encoded, forKey: coursesKey)
        }
    }
    
    func loadCourses() -> [Course] {
        if let data = UserDefaults.standard.data(forKey: coursesKey),
           let courses = try? JSONDecoder().decode([Course].self, from: data) {
            return courses
        }
        return []
    }
    
    func saveSkills(_ skills: [Skill]) {
        if let encoded = try? JSONEncoder().encode(skills) {
            UserDefaults.standard.set(encoded, forKey: skillsKey)
        }
    }
    
    func loadSkills() -> [Skill] {
        if let data = UserDefaults.standard.data(forKey: skillsKey),
           let skills = try? JSONDecoder().decode([Skill].self, from: data) {
            return skills
        }
        return []
    }
    
    func saveProgress(_ progress: ProgressData) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let encoded = try encoder.encode(progress)
            UserDefaults.standard.set(encoded, forKey: progressKey)
        } catch {
            print("Error saving progress: \(error)")
        }
    }
    
    func loadProgress() -> ProgressData? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let data = UserDefaults.standard.data(forKey: progressKey) else {
            return nil
        }
        
        do {
            return try decoder.decode(ProgressData.self, from: data)
        } catch {
            print("Error loading progress: \(error)")
            return nil
        }
    }
    
    func saveAchievements(_ achievements: [Achievement]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        if let encoded = try? encoder.encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }
    
    func loadAchievements() -> [Achievement] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let achievements = try? decoder.decode([Achievement].self, from: data) {
            return achievements
        }
        return []
    }
    
    func saveDailyActivity(_ activity: [ActivityPoint]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        if let encoded = try? encoder.encode(activity) {
            UserDefaults.standard.set(encoded, forKey: dailyActivityKey)
        }
    }
    
    func loadDailyActivity() -> [ActivityPoint] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let data = UserDefaults.standard.data(forKey: dailyActivityKey),
           let activity = try? decoder.decode([ActivityPoint].self, from: data) {
            return activity
        }
        return []
    }
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    func loadUser() -> User? {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }
}
