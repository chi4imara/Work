import SwiftUI
import GLib

@main
struct DoDidDoneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showingSplash = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    private var showingOnboarding: Bool {
        !hasCompletedOnboarding
    }
    
    init() {
        FontLoader.loadFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                if showingOnboarding {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                } else {
                    MainTabView()
                }
            }
        }
    }
}
