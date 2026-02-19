import SwiftUI

@main
struct Glit17App: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade: AppFacade
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashScreenView()) {
                MainAppView()
            }
        }
    }
}
