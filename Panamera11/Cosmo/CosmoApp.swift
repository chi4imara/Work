import SwiftUI

@main
struct CosmoApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                MainTabView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
