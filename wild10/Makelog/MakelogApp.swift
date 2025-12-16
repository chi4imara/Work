import SwiftUI
import LibSync

@main
struct MakelogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                Group {
                    if !appViewModel.hasSeenOnboarding {
                        OnboardingView(appViewModel: appViewModel)
                    } else {
                        MainView()
                    }
                }
            }
        }
    }
}
