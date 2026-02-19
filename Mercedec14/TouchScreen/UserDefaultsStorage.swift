import Foundation

enum UserDefaultsStorage {
    private static let defaults = UserDefaults.standard
    
    enum Key {
        static let onboardingCompleted = "onboardingCompleted"
        static let masters = "relaxme.masters"
        static let catalogSessions = "relaxme.catalogSessions"
        static let bookedSessions = "relaxme.bookedSessions"
        static let stressLevels = "relaxme.stressLevels"
        static let currentUser = "relaxme.currentUser"
    }
    
    static func save<T: Encodable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: key)
        } catch {
            print("UserDefaultsStorage save error for \(key): \(error)")
        }
    }
    
    static func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("UserDefaultsStorage load error for \(key): \(error)")
            return nil
        }
    }
    
    static func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
