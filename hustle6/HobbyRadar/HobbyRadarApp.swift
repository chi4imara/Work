import SwiftUI
import GLib

@main
struct HobbyRadarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                AppRootView()
            }
        }
    }
}
