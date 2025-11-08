import SwiftUI
import GLib

@main
struct JoyJournalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                AppController()
                    .preferredColorScheme(.light)
            }
        }
    }
}
