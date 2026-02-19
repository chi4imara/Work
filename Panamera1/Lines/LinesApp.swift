import SwiftUI

@main
struct LinesApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                AppController()
            }
        }
    }
}
