import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var appState: AppState = .onboarding
    
    var body: some View {
        Group {
            if !dataManager.hasCompletedOnboarding {
                OnboardingView()
                    .environmentObject(dataManager)
            } else {
                MainTabView()
                    .environmentObject(dataManager)
            }
        }
        .onAppear {
            startSplashTimer()
        }
    }
    
    private func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                if dataManager.hasCompletedOnboarding {
                    appState = .main
                } else {
                    appState = .onboarding
                }
            }
        }
    }
}

#Preview {
    AppRootView()
        .environmentObject(DataManager.shared)
}
