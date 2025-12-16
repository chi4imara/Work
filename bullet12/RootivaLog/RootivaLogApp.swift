import SwiftUI
import LibSync

@main
struct RootivaLogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = FontManager.shared
    }
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppCoordinator()
            }
        }
    }
}
