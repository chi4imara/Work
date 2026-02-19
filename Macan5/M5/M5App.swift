import SwiftUI
import LibSync

@main
struct M5App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                   if !hasCompletedOnboarding {
                        OnboardingView {
                            hasCompletedOnboarding = true
                            showingOnboarding = false
                        }
                    } else {
                        MainTabView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showingSplash)
                .animation(.easeInOut(duration: 0.5), value: showingOnboarding)
            }
        }
    }
}
