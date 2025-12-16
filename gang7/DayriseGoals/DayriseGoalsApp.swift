import SwiftUI
import LibSync

@main
struct DayriseGoalsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if appViewModel.showOnboarding {
                        OnboardingView(appViewModel: appViewModel)
                    } else {
                        MainTabView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplash)
                .animation(.easeInOut(duration: 0.5), value: appViewModel.showOnboarding)
            }
        }
    }
}
