import SwiftUI
import HookEther_Knowledge_Base

@main
struct StyleBloomApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appState = AppState()
    @State private var showSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                if !appState.hasCompletedOnboarding {
                    OnboardingView()
                        .environmentObject(appState)
                } else {
                    MainTabView()
                        .environmentObject(appState)
                }
            }
        }
    }
}
