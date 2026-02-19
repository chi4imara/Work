import SwiftUI

@main
struct ComputerFragApp: App {
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
                        OnboardingView(isCompleted: $showOnboarding)
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
