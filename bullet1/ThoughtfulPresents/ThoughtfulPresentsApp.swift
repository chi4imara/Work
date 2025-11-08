import SwiftUI
import LibSync

@main
struct ThoughtfulPresentsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isLoading = true
    @AppStorage(Constants.UserDefaultsKeys.onboardingComplete) private var isOnboardingComplete = false
    
    init() {
        FontLoader.loadFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                  if !isOnboardingComplete {
                        OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    } else {
                        MainTabView()
                    }
                }
            }
        }
    }
}
