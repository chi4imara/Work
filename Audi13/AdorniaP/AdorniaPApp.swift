import SwiftUI

@main
struct AdorniaPApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashScreen()) {
                ContentView()
            }
        }
    }
}
