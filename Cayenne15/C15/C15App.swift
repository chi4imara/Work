import SwiftUI
import LibSync

@main
struct C15App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if !appState.showOnboarding {
                        OnboardingView {
                            appState.completeOnboarding()
                        }
                    } else {
                        MainTabView()
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
