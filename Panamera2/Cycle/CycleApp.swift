import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct CycleApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
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
            }
        }
    }
}
