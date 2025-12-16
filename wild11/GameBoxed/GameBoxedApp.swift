import SwiftUI
import LibSync

@main
struct GameBoxedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                AppRootView()
            }
        }
    }
}
