import SwiftUI
import LibSync

@main
struct nspiroMintApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                   if showOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                            .onDisappear {
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            }
                    } else {
                        MainAppView()
                    }
                }
            }
        }
    }
}
