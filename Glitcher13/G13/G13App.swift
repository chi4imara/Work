import SwiftUI

@main
struct G13App: App {
    @UIApplicationDelegateAdaptor(AppHelper.self) var appHelper
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TinyToss(loader: SplashView()) {
                ContentView()
            }
        }
    }
}
