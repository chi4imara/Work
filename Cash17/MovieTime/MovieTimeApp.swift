import SwiftUI
import GLib

@main
struct MovieTimeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                ContentView()
                    .environment(\.managedObjectContext, CoreDataManager.shared.context)
            }
        }
    }
}
