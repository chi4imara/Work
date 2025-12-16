import SwiftUI
import LibSync

@main
struct FirstHumanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                Group {
                    if !appViewModel.hasCompletedOnboarding {
                        OnboardingView(appViewModel: appViewModel)
                    } else {
                        MainTabView()
                    }
                }
                .environmentObject(appViewModel)
            }
        }
    }
}
