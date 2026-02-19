import SwiftUI

@main
struct AffinityApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                ContentView()
            }
        }
    }
}
