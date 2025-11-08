import SwiftUI
import LibSync

@main
struct ScentaraLogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                MainAppView()
            }
        }
    }
}
