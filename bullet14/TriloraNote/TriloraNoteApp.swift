import SwiftUI
import LibSync

@main
struct TriloraNoteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = FontManager.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                MainAppView()
            }
        }
    }
}
