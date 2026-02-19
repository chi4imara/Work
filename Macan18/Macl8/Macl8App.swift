import SwiftUI
import LibSync

@main
struct Macl8App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                AppContainer()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
