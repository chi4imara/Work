import SwiftUI
import GLib

@main
struct PageFans_VibeClubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                CustomTabView()
            }
        }
    }
}
