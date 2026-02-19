import SwiftUI
import HookEther_Knowledge_Base

@main
struct CareerHerSApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                ContentView()
                    .environmentObject(appViewModel)
            }
        }
    }
}
