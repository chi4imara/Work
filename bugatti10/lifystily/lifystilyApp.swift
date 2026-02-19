import SwiftUI
import HookEther_Knowledge_Base

@main
struct lifystilyApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                ContentView()
            }
        }
    }
}
