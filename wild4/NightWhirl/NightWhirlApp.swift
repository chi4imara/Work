import SwiftUI
import LibSync

@main
struct NightWhirlApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                if showOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                    } else {
                        MainTabView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showSplash)
                .animation(.easeInOut(duration: 0.5), value: showOnboarding)
            }
        }
    }
}
