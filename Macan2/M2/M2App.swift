import SwiftUI
import LibSync

@main
struct M2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateViewModel()
    
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
