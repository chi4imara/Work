import SwiftUI
import GLib

@main
struct MyMomentsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppCoordinator()
            }
        }
    }
}
