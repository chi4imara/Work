import SwiftUI

@main
struct G15App: App {
    @UIApplicationDelegateAdaptor(AppHelper.self) var appHelper
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TinyToss(loader: SplashScreenView()) {
                ContentView()
            }
        }
    }
}
