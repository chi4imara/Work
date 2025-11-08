import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "GratitudeEntries_v1"
    
    private init() {}
    
    func saveEntries(_ entries: [GratitudeEntry]) {
        do {
            let data = try JSONEncoder().encode(entries)
            userDefaults.set(data, forKey: entriesKey)
        } catch {
            print("Failed to save entries: \(error)")
        }
    }
    
    func loadEntries() -> [GratitudeEntry] {
        guard let data = userDefaults.data(forKey: entriesKey) else {
            return []
        }
        
        do {
            let entries = try JSONDecoder().decode([GratitudeEntry].self, from: data)
            return entries.sorted { $0.date > $1.date }
        } catch {
            print("Failed to load entries: \(error)")
            return []
        }
    }
    
    func deleteAllEntries() {
        userDefaults.removeObject(forKey: entriesKey)
    }
    
    func exportEntries() -> Data? {
        let entries = loadEntries()
        return try? JSONEncoder().encode(entries)
    }
    
    func importEntries(from data: Data) -> Bool {
        do {
            let entries = try JSONDecoder().decode([GratitudeEntry].self, from: data)
            saveEntries(entries)
            return true
        } catch {
            print("Failed to import entries: \(error)")
            return false
        }
    }
}
