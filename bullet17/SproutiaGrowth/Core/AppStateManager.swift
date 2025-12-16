import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var isShowingSplash = true
    @Published var isShowingOnboarding = false
    @Published var hasCompletedOnboarding = false
    
    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if !hasCompletedOnboarding {
            isShowingOnboarding = true
        }
    }
    
    func completeSplash() {
        isShowingSplash = false
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        hasCompletedOnboarding = true
        isShowingOnboarding = false
    }
}
