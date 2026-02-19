import SwiftUI
import HookEther_Knowledge_Base

@main
struct WantlesscoApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                AppCoordinator()
            }
        }
    }
}
