import SwiftUI
import LibSync

@main
struct KindsyDaybookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var mainViewModel = MainViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if mainViewModel.showOnboarding {
                        OnboardingView(showOnboarding: $mainViewModel.showOnboarding)
                            .onDisappear {
                                mainViewModel.completeOnboarding()
                            }
                    } else {
                        MainTabView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: mainViewModel.showSplash)
                .animation(.easeInOut(duration: 0.5), value: mainViewModel.showOnboarding)
            }
        }
    }
}
