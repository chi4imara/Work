import SwiftUI
import LibSync

@main
struct M6App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
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
