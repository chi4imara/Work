import SwiftUI
import LibSync

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if appState.isShowingOnboarding {
                        OnboardingView(appState: appState)
                    } else {
                        MainTabView()
                            .environmentObject(appState)
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: appState.isShowingSplash)
                .animation(.easeInOut(duration: 0.5), value: appState.isShowingOnboarding)
            }
        }
    }
}
