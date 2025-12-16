import SwiftUI
import LibSync

@main
struct GlamMuseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                    if appState.isFirstLaunch {
                        OnboardingView(appState: appState)
                    } else {
                        MainTabView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: appState.isLoading)
                .animation(.easeInOut(duration: 0.5), value: appState.isFirstLaunch)
            }
        }
    }
}
