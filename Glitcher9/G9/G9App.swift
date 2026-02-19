import SwiftUI

@main
struct G9App: App {
    @UIApplicationDelegateAdaptor(AppHelper.self) var appHelper
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            TinyToss(loader: SplashScreenView()) {
                ContentView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
