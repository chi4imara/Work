import SwiftUI

enum AppState {
    case onboarding
    case main
}

struct AppCoordinator: View {
    @State private var appState: AppState = .onboarding
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        _ = FontLoader.shared
    }
    
    var body: some View {
        ZStack {
            switch appState {
            case .onboarding:
                OnboardingView {
                    hasCompletedOnboarding = true
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState = .main
                    }
                }
                
            case .main:
                MainContainerView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState)
    }
}

#Preview {
    AppCoordinator()
}
