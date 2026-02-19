import SwiftUI

@main
struct ToolmarkCApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @State private var showSplash = true
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen(showSplash: $showSplash)) {
                ZStack {
                    if showOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                            .onDisappear {
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            }
                    } else {
                        NavigationStack {
                            MainTabView()
                                .navigationBarHidden(true)
                        }
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
