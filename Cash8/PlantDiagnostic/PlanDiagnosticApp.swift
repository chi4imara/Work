import SwiftUI

@main
struct PlanDiagnosticApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isFirstLaunch {
                SplashScreenView()
                    .environmentObject(appState)
            } else if appState.showOnboarding {
                OnboardingView()
                    .environmentObject(appState)
            } else {
                MainTabView()
                    .environmentObject(appState)
            }
        }
    }
}
