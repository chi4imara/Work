import SwiftUI

@main
struct DefineMeApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                ZStack {
                    if !showOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .navigationBarHidden(true)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showSplash)
                .animation(.easeInOut(duration: 0.5), value: showOnboarding)
            }
        }
    }
}
