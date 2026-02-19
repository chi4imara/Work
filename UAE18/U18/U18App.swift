import SwiftUI
import LibSync

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var workoutManager = WorkoutManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                if hasSeenOnboarding {
                    MainTabView()
                        .environmentObject(workoutManager)
                } else {
                    OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                }
            }
        }
    }
}
