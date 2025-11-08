import SwiftUI
import GLib

@main
struct ArchiveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                MainAppView()
            }
        }
    }
}
