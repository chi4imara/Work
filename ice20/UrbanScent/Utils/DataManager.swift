import Foundation

class DataManager {
    static let shared = DataManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys {
        static let scentEntries = "ScentEntries"
        static let hasLaunchedBefore = "HasLaunchedBefore"
        static let appVersion = "AppVersion"
    }
    
    func saveScentEntries(_ entries: [ScentEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: Keys.scentEntries)
        }
    }
    
    func loadScentEntries() -> [ScentEntry] {
        guard let data = userDefaults.data(forKey: Keys.scentEntries),
              let entries = try? JSONDecoder().decode([ScentEntry].self, from: data) else {
            return []
        }
        return entries.sorted { $0.date > $1.date }
    }
    
    func setHasLaunchedBefore(_ value: Bool) {
        userDefaults.set(value, forKey: Keys.hasLaunchedBefore)
    }
    
    func hasLaunchedBefore() -> Bool {
        return userDefaults.bool(forKey: Keys.hasLaunchedBefore)
    }
    
    func getCurrentAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    func getStoredAppVersion() -> String {
        return userDefaults.string(forKey: Keys.appVersion) ?? ""
    }
    
    func setStoredAppVersion(_ version: String) {
        userDefaults.set(version, forKey: Keys.appVersion)
    }
    
    func performDataMigrationIfNeeded() {
        let currentVersion = getCurrentAppVersion()
        let storedVersion = getStoredAppVersion()
        
        if storedVersion.isEmpty {
            setStoredAppVersion(currentVersion)
        } else if storedVersion != currentVersion {
            migrateData(from: storedVersion, to: currentVersion)
            setStoredAppVersion(currentVersion)
        }
    }
    
    private func migrateData(from oldVersion: String, to newVersion: String) {
        print("Migrating data from version \(oldVersion) to \(newVersion)")
    }
    
    func clearAllData() {
        userDefaults.removeObject(forKey: Keys.scentEntries)
        userDefaults.removeObject(forKey: Keys.hasLaunchedBefore)
    }
}
