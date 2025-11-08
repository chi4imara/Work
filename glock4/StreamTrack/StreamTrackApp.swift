import SwiftUI
import GLib

@main
struct StreamTrackApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontRegistrar.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                MainAppView()
            }
        }
    }
}
