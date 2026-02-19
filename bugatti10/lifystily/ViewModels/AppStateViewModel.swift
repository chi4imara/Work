import Foundation
import SwiftUI
import Combine

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch: Bool
    @Published var hasCompletedOnboarding: Bool
    @Published var isLoading: Bool = true
    @Published var selectedTab: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "is_first_launch"
    private let onboardingKey = "has_completed_onboarding"
    
    init() {
        self.isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
        self.hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLoading = false
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
        userDefaults.set(true, forKey: firstLaunchKey)
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        userDefaults.set(false, forKey: onboardingKey)
    }
}
