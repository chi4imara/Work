import SwiftUI
import LibSync

@main
struct DailyLoveBitesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDeletegate
    
    init() {
        FontManager.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                AppRootView()
            }
        }
    }
}
