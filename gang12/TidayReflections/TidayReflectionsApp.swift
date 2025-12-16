import SwiftUI
import LibSync

@main
struct TidayReflectionsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                MainAppView()
            }
        }
    }
}
