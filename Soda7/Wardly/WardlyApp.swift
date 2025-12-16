import SwiftUI
import LibSync

@main
struct WardlyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateViewModel()
    @StateObject private var itemsViewModel = ItemsViewModel()
    
    init() {
        FontManager.loadFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                RootView()
                    .environmentObject(appState)
                    .environmentObject(itemsViewModel)
            }
        }
    }
}
