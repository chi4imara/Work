import SwiftUI
import LibSync

@main
struct U16App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var workoutViewModel = WorkoutViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                FriendsFitnessApp()
                    .environmentObject(workoutViewModel)
            }
        }
    }
}
