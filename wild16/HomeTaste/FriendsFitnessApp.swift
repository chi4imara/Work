import SwiftUI
import LibSync

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var recipeStore = RecipeStore()
    @StateObject private var noteStore = NoteStore()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                if !hasSeenOnboarding {
                    OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                } else {
                    MainTabView()
                        .environmentObject(recipeStore)
                        .environmentObject(noteStore)
                }
            }
        }
    }
}
