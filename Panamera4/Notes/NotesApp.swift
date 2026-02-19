import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct HairCareApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @StateObject private var procedureStore = ProcedureStore()
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                if !showOnboarding {
                    OnboardingView(isComplete: $showOnboarding)
                } else {
                    NavigationStack {
                        MainTabView()
                            .environmentObject(procedureStore)
                            .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}
