import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var appState: AppState = .onboarding
    
    private let hasSeenOnboardingKey = "HasSeenOnboarding"
    
    enum AppState {
        case onboarding
        case main
    }
    
    init() {
        checkOnboardingStatus()
    }
    
    private func checkOnboardingStatus() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
        print("AppStateManager: hasSeenOnboarding = \(hasSeenOnboarding)")
        
        if hasSeenOnboarding {
            appState = .main
            print("AppStateManager: Setting appState to .main")
        } else {
            appState = .onboarding
            print("AppStateManager: Setting appState to .onboarding")
        }
    }
    
    func completeOnboarding() {
        print("AppStateManager: Completing onboarding")
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
        print("AppStateManager: Saved hasSeenOnboarding = true to UserDefaults")
        withAnimation(.easeInOut(duration: 0.5)) {
            appState = .main
        }
    }
    
    func completeSplash() {
        checkOnboardingStatus()
    }
}

struct AppRootView: View {
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some View {
        Group {
            switch appStateManager.appState {
            case .onboarding:
                OnboardingView {
                    appStateManager.completeOnboarding()
                }
            case .main:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appStateManager.appState)
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}
