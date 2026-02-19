import SwiftUI

struct AppCoordinator: View {
    @State private var appState: AppState = .splash
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView {
                    hasSeenOnboarding = true
                    
                }
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

enum AppState {
    case splash
    case onboarding
    case main
}
