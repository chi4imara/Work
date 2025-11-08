import SwiftUI
import GLib

@main
struct SoulBloomApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen(isActive: .constant(true))) {
                ZStack {
                    if !hasCompletedOnboarding {
                        OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
                    } else {
                        MainTabView()
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
