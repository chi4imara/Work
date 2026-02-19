import SwiftUI
import LibSync

@main
struct U5App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isShowingSplash = true
    @State private var isShowingOnboarding = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                   if !hasSeenOnboarding {
                        OnboardingView(showOnboarding: $isShowingOnboarding)
                    } else {
                        MainTabView()
                    }
                }
            }
        }
    }
}
