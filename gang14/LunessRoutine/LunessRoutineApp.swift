import SwiftUI
import LibSync

@main
struct LunessRoutineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = FontManager.shared.registerFonts()

    }
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                MainTabView()
                    .preferredColorScheme(.light)
            }
        }
    }
}
