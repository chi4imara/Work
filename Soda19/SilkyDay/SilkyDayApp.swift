import SwiftUI
import LibSync

@main
struct SilkyDayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = FontManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                MainTabView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
