import SwiftUI
import HookEther_Knowledge_Base

@main
struct YourPowerApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                ContentView()
                    .preferredColorScheme(.light)
            }
        }
    }
}
