import SwiftUI
import LibSync

@main
struct ReciplyBookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
    @State private var showOnboarding = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                   if showOnboarding && !hasSeenOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                            .onDisappear {
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            }
                    } else {
                        MainTabView()
                    }
                }
            }
        }
    }
    
    private var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }
}
