import SwiftUI
import GLib

@main
struct Cash9App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                ContentView()
            }
        }
    }
}
