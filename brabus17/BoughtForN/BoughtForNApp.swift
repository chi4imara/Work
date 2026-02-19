import SwiftUI

@main
struct BoughtForNApp: App {
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
