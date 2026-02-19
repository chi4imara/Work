import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isOnboardingCompleted = false
    @Published var showSplash = true
    @Published var selectedTab = 0
    @Published var userProfile: UserProfile?
    let mealPlanViewModel = MealPlanViewModel()
    
    init() {
        isOnboardingCompleted = UserDefaults.standard.bool(forKey: "onboarding_completed")
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: "onboarding_completed")
    }
}
