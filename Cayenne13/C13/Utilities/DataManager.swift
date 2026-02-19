import Foundation

class DataManager {
    static let shared = DataManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func saveWatches(_ watches: [Watch]) {
        if let encoded = try? JSONEncoder().encode(watches) {
            userDefaults.set(encoded, forKey: AppConstants.watchesKey)
        }
    }
    
    func loadWatches() -> [Watch] {
        guard let data = userDefaults.data(forKey: AppConstants.watchesKey),
              let decoded = try? JSONDecoder().decode([Watch].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func setHasSeenOnboarding(_ hasSeen: Bool) {
        userDefaults.set(hasSeen, forKey: AppConstants.hasSeenOnboardingKey)
    }
    
    func hasSeenOnboarding() -> Bool {
        return userDefaults.bool(forKey: AppConstants.hasSeenOnboardingKey)
    }
    
    func validateWatch(_ watch: Watch) -> Bool {
        return !watch.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func getMostWornWatch(from watches: [Watch]) -> Watch? {
        return watches.max { $0.wearingDays.count < $1.wearingDays.count }
    }
    
    func getTotalWearingDays(from watches: [Watch]) -> Int {
        return watches.reduce(0) { $0 + $1.wearingDays.count }
    }
}
