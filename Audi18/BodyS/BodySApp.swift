import SwiftUI
import HookEther_Knowledge_Base

@main
struct BodySApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @State private var isShowingSplash = true
    @State private var isShowingOnboarding = UserDefaults.standard.bool(forKey: "Onboarding")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView(isShowingSplash: $isShowingSplash)) {
                ZStack {
                    if !isShowingOnboarding {
                        OnboardingView(isShowingOnboarding: $isShowingOnboarding)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .navigationBarHidden(true)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: isShowingSplash)
                .animation(.easeInOut(duration: 0.5), value: isShowingOnboarding)
            }
        }
    }
}
