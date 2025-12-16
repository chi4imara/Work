import SwiftUI
import LibSync

@main
struct WickMoodApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var isShowingSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                  if !hasCompletedOnboarding {
                        OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
                    } else {
                        MainTabView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: isShowingSplash)
                .animation(.easeInOut(duration: 0.5), value: hasCompletedOnboarding)
            }
        }
    }
}
