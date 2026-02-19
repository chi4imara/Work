import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var currentState: AppState = .onboarding
    
    enum AppState {
        case onboarding
        case main
    }
    
    init() {
        checkOnboardingStatus()
    }
    
    private func checkOnboardingStatus() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
            if hasCompletedOnboarding {
                self.currentState = .main
            } else {
                self.currentState = .onboarding
            }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        currentState = .main
    }
}

struct AppRootView: View {
    @StateObject private var appStateManager = AppStateManager()
    @State private var showOnboarding = false
    
    var body: some View {
        Group {
            switch appStateManager.currentState {
            case .onboarding:
                OnboardingView(showOnboarding: .constant(true))
                    .environmentObject(appStateManager)
            case .main:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appStateManager.currentState)
    }
}

#Preview {
    AppRootView()
}
