import SwiftUI
import HookEther_Knowledge_Base

@main
struct FactsOfDayApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                AppRootView()
            }
        }
    }
}
