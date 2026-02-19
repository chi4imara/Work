import SwiftUI

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appState = AppStateManager()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                if appState.hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView()
                        .environmentObject(appState)
                }
            }
        }
    }
}
