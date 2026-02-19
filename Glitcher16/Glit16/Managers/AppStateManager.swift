import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var showOnboarding: Bool = false
    @Published var isLoading: Bool = true
    
    init() {
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.hasLaunchedBefore)
        if !hasLaunchedBefore {
            isFirstLaunch = true
            showOnboarding = true
            UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.hasLaunchedBefore)
        } else {
            isFirstLaunch = false
            showOnboarding = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.AnimationDurations.splash) {
            self.isLoading = false
        }
    }
    
    func completeOnboarding() {
        showOnboarding = false
    }
}
