import Foundation

final class UserDefaultsStorage {
    static let shared = UserDefaultsStorage()
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private enum Keys {
        static let userProfile = "userProfile"
        static let activities = "activities"
        static let events = "events"
        static let progressData = "progressData"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
        
    func saveUserProfile(_ profile: UserProfile) {
        save(profile, forKey: Keys.userProfile)
    }
    
    func loadUserProfile() -> UserProfile? {
        load(forKey: Keys.userProfile)
    }
    
    func saveHasCompletedOnboarding(_ value: Bool) {
        defaults.set(value, forKey: Keys.hasCompletedOnboarding)
    }
    
    func loadHasCompletedOnboarding() -> Bool {
        defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }
        
    func saveActivities(_ activities: [Activity]) {
        save(activities, forKey: Keys.activities)
    }
    
    func loadActivities() -> [Activity]? {
        load(forKey: Keys.activities)
    }
        
    func saveEvents(_ events: [LeisureEvent]) {
        save(events, forKey: Keys.events)
    }
    
    func loadEvents() -> [LeisureEvent]? {
        load(forKey: Keys.events)
    }
        
    private struct ProgressDataStorage: Codable {
        struct DateIntEntry: Codable {
            let date: Date
            let value: Int
        }
        struct DateMoodEntry: Codable {
            let date: Date
            let mood: MoodLevel
        }
        let weeklyActivities: [DateIntEntry]
        let moodTracking: [DateMoodEntry]
        let achievements: [Achievement]
        let totalActivitiesCompleted: Int
        let currentStreak: Int
        let longestStreak: Int
    }
    
    func saveProgressData(_ data: ProgressData) {
        let storage = ProgressDataStorage(
            weeklyActivities: data.weeklyActivities.map { ProgressDataStorage.DateIntEntry(date: $0.key, value: $0.value) },
            moodTracking: data.moodTracking.map { ProgressDataStorage.DateMoodEntry(date: $0.key, mood: $0.value) },
            achievements: data.achievements,
            totalActivitiesCompleted: data.totalActivitiesCompleted,
            currentStreak: data.currentStreak,
            longestStreak: data.longestStreak
        )
        save(storage, forKey: Keys.progressData)
    }
    
    func loadProgressData() -> ProgressData? {
        guard let data = defaults.data(forKey: Keys.progressData) else { return nil }
        do {
            let storage = try decoder.decode(ProgressDataStorage.self, from: data)
            var result = ProgressData()
            result.weeklyActivities = Dictionary(uniqueKeysWithValues: storage.weeklyActivities.map { ($0.date, $0.value) })
            result.moodTracking = Dictionary(uniqueKeysWithValues: storage.moodTracking.map { ($0.date, $0.mood) })
            result.achievements = storage.achievements
            result.totalActivitiesCompleted = storage.totalActivitiesCompleted
            result.currentStreak = storage.currentStreak
            result.longestStreak = storage.longestStreak
            return result
        } catch {
            print("UserDefaultsStorage: Failed to load progressData - \(error)")
            return nil
        }
    }
        
    private func save<T: Encodable>(_ value: T, forKey key: String) {
        do {
            let data = try encoder.encode(value)
            defaults.set(data, forKey: key)
        } catch {
            print("UserDefaultsStorage: Failed to save \(key) - \(error)")
        }
    }
    
    private func load<T: Decodable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("UserDefaultsStorage: Failed to load \(key) - \(error)")
            return nil
        }
    }
}
