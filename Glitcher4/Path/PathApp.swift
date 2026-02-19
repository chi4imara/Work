import SwiftUI
import LibSync

@main
struct PathApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appStateManager = AppStateManager()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if !appStateManager.hasCompletedOnboarding {
                        OnboardingView {
                            appStateManager.completeOnboarding()
                        }
                    } else {
                        MainTabView()
                    }
                }
                .environmentObject(appStateManager)
            }
        }
    }
}
