import SwiftUI
import LibSync

@main
struct HomeGearApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateViewModel()
    @StateObject private var viewModel = InventoryViewModel()

    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                Group {
                    if appState.isFirstLaunch {
                        OnboardingView {
                            appState.completeOnboarding()
                        }
                    } else {
                        MainTabView()
                            .environmentObject(viewModel)
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
