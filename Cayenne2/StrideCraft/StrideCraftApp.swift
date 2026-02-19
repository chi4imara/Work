import SwiftUI
import LibSync

@main
struct StrideCraftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
    @State private var showOnboarding = true
    
    init() {
        FontManager.shared.registerFonts()
        
        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.hasSeenOnboarding) {
            _showOnboarding = State(initialValue: false)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if showOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                            .onDisappear {
                                UserDefaults.standard.set(true, forKey: Constants.UserDefaults.hasSeenOnboarding)
                            }
                    } else {
                        MainTabView()
                    }
                }
            }
        }
    }
}
