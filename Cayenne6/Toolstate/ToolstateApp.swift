import SwiftUI
import LibSync

@main
struct ToolstateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateManager()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}
