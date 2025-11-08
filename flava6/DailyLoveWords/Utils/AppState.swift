import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isFirstLaunch: Bool
    @Published var hasCompletedOnboarding: Bool
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        self.isFirstLaunch = !userDefaults.bool(forKey: "hasLaunchedBefore")
        self.hasCompletedOnboarding = userDefaults.bool(forKey: "hasCompletedOnboarding")
        
        if isFirstLaunch {
            userDefaults.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: "hasCompletedOnboarding")
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        userDefaults.set(false, forKey: "hasCompletedOnboarding")
    }
}
