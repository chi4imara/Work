import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    static let shared = AppStateManager()
    
    @Published var showingSplash = true
    @Published var isOnboardingComplete = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "OnboardingComplete"
    
    private init() {
        loadOnboardingState()
    }
    
    private func loadOnboardingState() {
        isOnboardingComplete = userDefaults.bool(forKey: onboardingKey)
        print("AppStateManager: Loading onboarding state - \(isOnboardingComplete)")
    }
    
    func completeOnboarding() {
        print("AppStateManager: Completing onboarding")
        userDefaults.set(true, forKey: onboardingKey)
        userDefaults.synchronize()
        isOnboardingComplete = true
        print("AppStateManager: Onboarding completed - \(isOnboardingComplete)")
    }
    
    func hideSplash() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showingSplash = false
        }
    }
    
    func resetOnboarding() {
        userDefaults.removeObject(forKey: onboardingKey)
        userDefaults.synchronize()
        isOnboardingComplete = false
    }
}
