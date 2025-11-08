import SwiftUI
import GLib

@main
struct OnlyWisdom_YourQuotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                MainContainerView()
            }
        }
    }
}
