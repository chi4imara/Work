import SwiftUI
import LibSync

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ContentView()
                    .environmentObject(appState)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
