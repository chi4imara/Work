import SwiftUI
import LibSync

@main
struct AromaMixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var mainViewModel = MainAppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                ContentView()
                    .environmentObject(mainViewModel)
            }
        }
    }
}
