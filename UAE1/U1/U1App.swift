import SwiftUI
import LibSync

@main
struct U1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                AppContainerView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
