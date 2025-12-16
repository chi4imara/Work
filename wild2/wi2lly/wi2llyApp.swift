import SwiftUI
import LibSync

@main
struct wi2llyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppController()
            }
        }
    }
}
