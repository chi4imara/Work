import SwiftUI
import GSource

@main
struct G14App: App {
    @UIApplicationDelegateAdaptor(AppHelper.self) var appHelper
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            TinyToss(loader: SplashView()) {
                ContentView()
            }
        }
    }
}
