import SwiftUI
import LibSync

@main
struct StreakMindApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isShowingSplash = true
    @AppStorage("OnboardingComplete") private var isOnboardingComplete = false
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                   if !isOnboardingComplete {
                        OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    } else {
                        MainTabView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: isShowingSplash)
                .animation(.easeInOut(duration: 0.5), value: isOnboardingComplete)
            }
        }
    }
}
