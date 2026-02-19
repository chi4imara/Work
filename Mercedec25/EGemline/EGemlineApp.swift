import SwiftUI

@main
struct JewelMateApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appState = AppState()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                if !appState.hasCompletedOnboarding {
                    OnboardingView()
                        .environmentObject(appState)
                } else {
                    NavigationStack {
                        MainTabView()
                            .environmentObject(appState)
                            .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}
