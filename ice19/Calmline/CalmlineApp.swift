import SwiftUI
import LibSync

@main
struct CalmlineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
        _ = NotificationManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                Group {
                    if appViewModel.isFirstLaunch {
                        OnboardingScreen() {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                appViewModel.completeOnboarding()
                            }
                        }
                    } else {
                        MainTabView()
                    }
                }
                .environmentObject(appViewModel)
            }
        }
    }
}
