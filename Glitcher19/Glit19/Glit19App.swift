import SwiftUI

@main
struct Glit19App: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade: AppFacade
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                ContentView()
            }
        }
    }
}
