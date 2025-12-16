import SwiftUI
import LibSync

@main
struct CareApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataManager = DataManager()
    @State private var showSplash = true
    
    init() {
        _ = FontManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                
                MainTabView()
                    .environmentObject(dataManager)
            }
        }
    }
}
