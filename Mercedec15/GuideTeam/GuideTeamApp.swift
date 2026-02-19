import SwiftUI

@main
struct GuideTeamApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @State private var isLoading = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                PostSplashView()
            }
        }
    }
}
