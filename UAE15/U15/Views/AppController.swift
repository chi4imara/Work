import SwiftUI

enum AppState {
    case splash
    case onboarding
    case main
}

struct AppController: View {
    @State private var appState: AppState = .splash
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView {
                    hasCompletedOnboarding = true
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState = .main
                    }
                }
            } else {
                NavigationView {
                    MainTabView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}

#Preview {
    AppController()
}
