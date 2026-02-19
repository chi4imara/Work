import SwiftUI
import LibSync

@main
struct U14App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isShowingSplash = true
    @State private var isShowingOnboarding = false
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    BackgroundView()
                    
                   if !hasCompletedOnboarding {
                        OnboardingView(isShowingOnboarding: $isShowingOnboarding)
                            .onAppear {
                                isShowingOnboarding = true
                            }
                    } else {
                        MainTabView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: isShowingSplash)
                .animation(.easeInOut(duration: 0.5), value: isShowingOnboarding)
                .onChange(of: isShowingSplash) { newValue in
                    if !newValue && !hasCompletedOnboarding {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isShowingOnboarding = true
                        }
                    }
                }
            }
        }
    }
}
