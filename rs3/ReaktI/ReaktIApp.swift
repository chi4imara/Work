import SwiftUI

@main
struct ReaktIApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appState = AppStateViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                ZStack {
                    if !appState.hasCompletedOnboarding {
                        OnboardingView(appState: appState)
                            .transition(.slide)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .transition(.opacity)
                                .navigationBarHidden(true)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: appState.showingSplash)
                .animation(.easeInOut(duration: 0.5), value: appState.hasCompletedOnboarding)
            }
        }
    }
}
