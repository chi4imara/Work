import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let hasSeenOnboardingKey = "HasSeenOnboarding"
    
    private init() {}
    
    var hasSeenOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasSeenOnboardingKey)
        }
    }
}