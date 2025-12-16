import SwiftUI
import LibSync

@main
struct HerListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                   if appViewModel.isFirstLaunch {
                        OnboardingView {
                            appViewModel.completedOnboarding()
                        }
                    } else {
                        MainView()
                    }
                }
                .preferredColorScheme(.light)
            }
        }
    }
}
