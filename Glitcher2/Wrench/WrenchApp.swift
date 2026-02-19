import SwiftUI
import LibSync

@main
struct WrenchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                AppCoordinator()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
