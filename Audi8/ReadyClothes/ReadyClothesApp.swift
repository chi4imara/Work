import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct ReadyClothesApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaultsManager.shared.hasSeenOnboarding
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashScreenView()) {
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
