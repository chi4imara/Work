import SwiftUI

enum AppState {
    case onboarding
    case main
}

struct AppCoordinator: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView {
                    hasCompletedOnboarding = true
                    withAnimation(.easeInOut(duration: 0.5)) {
                    }
                }
            } else {
                MainTabView()
            }
        }
        .onAppear {
            FontManager.registerFonts()
        }
        .task {
            await MainActor.run {
                FontManager.registerFonts()
            }
        }
    }
    
}

#Preview {
    AppCoordinator()
}
