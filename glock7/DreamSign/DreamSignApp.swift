import SwiftUI
import GLib

@main
struct DreamSignApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showMainView = false
    
    init() {
        FontManager.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView(showMainView: $showMainView)) {
                if showMainView {
                    MainView()
                }
            }
        }
    }
}
