import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct SeasonJourApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                AppView()
            }
        }
    }
}
