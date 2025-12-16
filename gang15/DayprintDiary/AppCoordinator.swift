import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentState: AppState = .splash
    
    enum AppState {
        case splash
        case onboarding
        case main
    }
    
    init() {
        if UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.currentState = .main
            }
        }
    }
    
    func completeSplash() {
        if UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            currentState = .main
        } else {
            currentState = .onboarding
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        currentState = .main
    }
}

struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        Group {
            switch coordinator.currentState {
            case .splash:
                SplashScreen {
                    coordinator.completeSplash()
                }
                
            case .onboarding:
                OnboardingView {
                    coordinator.completeOnboarding()
                }
                
            case .main:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: coordinator.currentState)
    }
}
