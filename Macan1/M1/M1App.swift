import SwiftUI
import LibSync

@main
struct M1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                Group {
                    if showOnboarding {
                        OnboardingView(isCompleted: Binding(
                            get: { !showOnboarding },
                            set: { newValue in
                                if newValue {
                                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showOnboarding = false
                                    }
                                }
                            }
                        ))
                    } else {
                        MainContainerView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showSplash)
                .animation(.easeInOut(duration: 0.5), value: showOnboarding)
            }
        }
    }
}
