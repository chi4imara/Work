import SwiftUI
import LibSync

@main
struct DailyLoveWordsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                  if !hasCompletedOnboarding {
                        OnboardingView {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showingOnboarding = false
                                hasCompletedOnboarding = true
                                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            }
                        }
                    } else {
                        MainTabView()
                    }
                }
                .onAppear {
                    FontManager.registerFonts()
                    DataMigrationManager.shared.migrateIfNeeded()
                }
            }
        }
    }
}
