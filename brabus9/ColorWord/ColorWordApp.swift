import SwiftUI

@main
struct ColorWordApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                MainContainerView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
