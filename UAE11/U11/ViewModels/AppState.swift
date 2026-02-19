import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isFirstLaunch: Bool
    @Published var hasSeenOnboarding: Bool
    
    init() {
        self.isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}
