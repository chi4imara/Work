import SwiftUI
import LibSync

@main
struct DishadayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var itemStore = ItemStore()
    
    init() {
        let _ = FontManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                MainAppView()
                    .environmentObject(itemStore)
            }
        }
    }
}
