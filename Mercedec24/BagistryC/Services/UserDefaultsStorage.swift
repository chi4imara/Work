import Foundation

final class UserDefaultsStorage {
    static let shared = UserDefaultsStorage()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let bags = "bags"
        static let user = "user"
        static let tryOnSessions = "tryOnSessions"
        static let achievements = "achievements"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
    
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    private init() {}
        
    func saveBags(_ bags: [Bag]) {
        guard let data = try? encoder.encode(bags) else { return }
        defaults.set(data, forKey: Keys.bags)
    }
    
    func loadBags() -> [Bag] {
        guard let data = defaults.data(forKey: Keys.bags),
              let bags = try? decoder.decode([Bag].self, from: data) else {
            return []
        }
        return bags
    }
        
    func saveUser(_ user: User) {
        guard let data = try? encoder.encode(user) else { return }
        defaults.set(data, forKey: Keys.user)
    }
    
    func loadUser() -> User? {
        guard let data = defaults.data(forKey: Keys.user),
              let user = try? decoder.decode(User.self, from: data) else {
            return nil
        }
        return user
    }
        
    func saveTryOnSessions(_ sessions: [TryOnSession]) {
        guard let data = try? encoder.encode(sessions) else { return }
        defaults.set(data, forKey: Keys.tryOnSessions)
    }
    
    func loadTryOnSessions() -> [TryOnSession] {
        guard let data = defaults.data(forKey: Keys.tryOnSessions),
              let sessions = try? decoder.decode([TryOnSession].self, from: data) else {
            return []
        }
        return sessions
    }
        
    func saveAchievements(_ achievements: [Achievement]) {
        guard let data = try? encoder.encode(achievements) else { return }
        defaults.set(data, forKey: Keys.achievements)
    }
    
    func loadAchievements() -> [Achievement]? {
        guard let data = defaults.data(forKey: Keys.achievements),
              let achievements = try? decoder.decode([Achievement].self, from: data) else {
            return nil
        }
        return achievements
    }
        
    func setOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: Keys.hasCompletedOnboarding)
    }
    
    func hasCompletedOnboarding() -> Bool {
        defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }
}
