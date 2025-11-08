import SwiftUI
import GLib

@main
struct MoodFans_AuraDayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                AppRootView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
