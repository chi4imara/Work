import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var hasCompletedOnboarding = false
    @Published var selectedTab = 0
    @Published var isLoading = true
    
    init() {
        print("AppState initializing...")
        
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        print("AppState: hasCompletedOnboarding = \(hasCompletedOnboarding), isFirstLaunch = \(isFirstLaunch)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            print("Finishing loading...")
            self?.isLoading = false
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        UserDefaults.standard.synchronize()
        print("Onboarding completed and saved to UserDefaults")
    }
}
