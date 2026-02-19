import SwiftUI
import LibSync

@main
struct M25App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if !showOnboarding {
                        OnboardingView(isCompleted: $showOnboarding)
                            .onDisappear {
                                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                                showOnboarding = true
                            }
                    } else {
                        MainAppView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showSplash)
                .animation(.easeInOut(duration: 0.5), value: showOnboarding)
            }
        }
    }
}
