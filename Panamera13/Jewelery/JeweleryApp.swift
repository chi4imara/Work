import SwiftUI

@main
struct JeweleryApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @StateObject private var appState = AppState()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashScreen()) {
                Group {
                    if !appState.hasCompletedOnboarding {
                        OnboardingView(appState: appState)
                    } else {
                        MainAppView()
                    }
                }
            }
        }
    }
}
