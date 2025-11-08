import SwiftUI
import GLib

@main
struct PlantSoulApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                ContentView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
