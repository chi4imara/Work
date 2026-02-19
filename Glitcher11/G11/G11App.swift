import SwiftUI

@main
struct G11App: App {
    @UIApplicationDelegateAdaptor(AppHelper.self) var appHelper
    @State private var showSplash = true
    @State private var isFirstLaunch = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TinyToss(loader: SplashScreen()) {
                ZStack {
                    if !isFirstLaunch {
                        OnboardingView(isFirstLaunch: $isFirstLaunch)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .navigationBarHidden(true)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showSplash)
                .animation(.easeInOut(duration: 0.5), value: isFirstLaunch)
            }
        }
    }
}
