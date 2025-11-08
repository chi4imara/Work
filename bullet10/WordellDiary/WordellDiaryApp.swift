import SwiftUI
import LibSync

@main
struct WordellDiaryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    init() {
        _ = FontLoader.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                    if !hasCompletedOnboarding {
                        OnboardingView {
                            hasCompletedOnboarding = true
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            showingOnboarding = false
                        }
                    } else {
                        MainView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showingSplash)
                .animation(.easeInOut(duration: 0.5), value: showingOnboarding)
            }
        }
    }
}
