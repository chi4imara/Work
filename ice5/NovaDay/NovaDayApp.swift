import SwiftUI
import LibSync

@main
struct NovaDayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppRootView()
            }
        }
    }
}
