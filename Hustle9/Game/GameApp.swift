import SwiftUI
import GLib

@main
struct GameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                SplashView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
