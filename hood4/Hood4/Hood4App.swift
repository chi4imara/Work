import SwiftUI
import GLib

@main
struct Hood4App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        AppFonts.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppRootView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
