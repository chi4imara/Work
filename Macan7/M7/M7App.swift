import SwiftUI
import LibSync

@main
struct M7App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                AppRootView()
            }
        }
    }
}
