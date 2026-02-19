import Foundation
import Combine

enum AppState {
    case splash
    case onboarding
    case main
}

class AppStateManager: ObservableObject {
    @Published var currentState: AppState = .splash
    @Published var hasCompletedOnboarding: Bool = false
    
    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Constants.UserDefaults.hasCompletedOnboarding)
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.hasCompletedOnboarding)
        currentState = .main
    }
    
    func startApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.hasCompletedOnboarding {
                self.currentState = .main
            } else {
                self.currentState = .onboarding
            }
        }
    }
}
