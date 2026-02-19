import SwiftUI
import HookEther_Knowledge_Base

@main
struct RelaxMeApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appState = AppStateManager()
    @State private var isLoading = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                if appState.isOnboardingCompleted {
                    MainTabView()
                        .environmentObject(appState)
                } else {
                    OnboardingView()
                        .environmentObject(appState)
                }
            }
        }
    }
}
