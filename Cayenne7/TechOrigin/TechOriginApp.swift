import SwiftUI
import LibSync

@main
struct TechOriginApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = FontManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ContentView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
