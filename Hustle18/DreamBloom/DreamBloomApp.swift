import SwiftUI
import GLib

@main
struct DreamBloomApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FontRegistration.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                ContentView()
            }
        }
    }
}
