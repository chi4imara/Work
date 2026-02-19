import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct BagframeHApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @State private var showMainApp = false
    @State private var isOnboardingCompleted: Bool = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView(showMainApp: $showMainApp)) {
                if !isOnboardingCompleted {
                    OnboardingView(showOnboarding: $isOnboardingCompleted)
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
