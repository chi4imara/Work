import SwiftUI
import LibSync

@main
struct CraftRouteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                MainAppView()
                    .environmentObject(appViewModel)
            }
        }
    }
}
