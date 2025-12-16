import SwiftUI
import LibSync

@main
struct PolishedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var manicureStore = ManicureStore()
    @StateObject private var ideaStore = IdeaStore()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                if hasSeenOnboarding {
                    MainTabView()
                        .environmentObject(manicureStore)
                        .environmentObject(ideaStore)
                } else {
                    OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                }
            }
        }
    }
}
