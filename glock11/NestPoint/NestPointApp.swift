import SwiftUI
import GLib

@main
struct NestPointApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = FontLoader.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppRootView()
                    .preferredColorScheme(.light)
            }
        }
    }
}
