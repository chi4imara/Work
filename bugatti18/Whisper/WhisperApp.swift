import SwiftUI
import HookEther_Knowledge_Base

@main
struct WhisperApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                ZStack {
                    if appViewModel.isFirstLaunch {
                        OnboardingView(appViewModel: appViewModel)
                    } else {
                        MainTabView()
                    }
                }
                .animation(Theme.Animation.medium, value: appViewModel.isLoading)
                .animation(Theme.Animation.medium, value: appViewModel.isFirstLaunch)
            }
        }
    }
}
