import SwiftUI
import GLib

@main
struct SmartDeskApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ContentView()
                    .preferredColorScheme(.light)
            }
        }
    }
}
