import SwiftUI
import LibSync

@main
struct U15App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppController()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
