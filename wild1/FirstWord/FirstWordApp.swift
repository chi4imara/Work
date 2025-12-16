import SwiftUI
import LibSync

@main
struct FirstWordApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppRootView()
            }
        }
    }
}
