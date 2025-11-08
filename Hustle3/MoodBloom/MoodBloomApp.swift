import SwiftUI
import GLib

@main
struct MoodBloomApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                AppContainer()
            }
        }
    }
}
