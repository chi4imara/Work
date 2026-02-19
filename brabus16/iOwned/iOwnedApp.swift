import SwiftUI
import HookEther_Knowledge_Base

@main
struct iOwnedApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                AppController()
                    .preferredColorScheme(.light)
            }
        }
    }
}
