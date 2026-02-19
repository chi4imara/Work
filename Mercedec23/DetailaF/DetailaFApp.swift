import SwiftUI

@main
struct DetailaFApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @State private var showingSplash = true
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                ZStack {
                    if hasCompletedOnboarding {
                        MainTabView()
                            .transition(.opacity)
                    } else {
                        OnboardingView(onComplete: {
                            hasCompletedOnboarding = true
                        })
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showingSplash)
                .animation(.easeInOut(duration: 0.5), value: hasCompletedOnboarding)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        showingSplash = false
                    }
                }
            }
        }
    }
}
