import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct ShapeStApp: App {
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
