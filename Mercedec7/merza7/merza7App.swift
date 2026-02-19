import SwiftUI

@main
struct SelfCareCoachApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @State private var isShowingSplash = true
    @State private var isShowingOnboarding = true
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                ZStack {
                    if !hasCompletedOnboarding {
                        OnboardingView(isShowingOnboarding: $hasCompletedOnboarding)
                    } else {
                        MainTabView()
                    }
                }
                .preferredColorScheme(.light)
            }
        }
    }
}
