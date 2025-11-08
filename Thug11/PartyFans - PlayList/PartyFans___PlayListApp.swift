import SwiftUI
import GLib

@main
struct PartyFans_PlayListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                AppContainerView()
            }
        }
    }
}
