import SwiftUI
import HookEther_Knowledge_Base

@main
struct AutoDriveUApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                MainTabView()
            }
        }
    }
}
