import SwiftUI

@main
struct UpliftApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                MainAppView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
