import SwiftUI
import LibSync

@main
struct C16App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                ZStack {
                    if !showOnboarding {
                        OnboardingView {
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showOnboarding = true
                            }
                        }
                    } else {
                        MainTabView()
                    }
                }
            }
        }
    }
}
