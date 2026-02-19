import SwiftUI
import HookEther_Knowledge_Base

@main
struct merz6App: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                ZStack {
                    if !appViewModel.showOnboarding {
                        OnboardingView {
                            appViewModel.completeOnboarding()
                        }
                    } else {
                        MainTabView()
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
