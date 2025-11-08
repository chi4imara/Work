import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var hasSeenOnboarding: Bool = false
    @Published var isLoading: Bool = true
    @Published var selectedTab: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadOnboardingState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLoading = false
        }
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    private func loadOnboardingState() {
        hasSeenOnboarding = userDefaults.bool(forKey: onboardingKey)
    }
}
