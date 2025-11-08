import SwiftUI
import GLib

@main
struct SparkNightApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelete
    
    init() {
        UIFont.registerCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                ContentView()
                    .environmentObject(appViewModel)
            }
        }
    }
}
