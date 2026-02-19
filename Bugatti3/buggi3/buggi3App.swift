import SwiftUI

@main
struct buggi3App: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
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
