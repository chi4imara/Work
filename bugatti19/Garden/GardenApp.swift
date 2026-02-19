import SwiftUI

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                MainContainerView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
