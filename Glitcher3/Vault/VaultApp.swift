import SwiftUI
import LibSync

@main
struct VaultApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var gadgetViewModel = GadgetViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ContentView()
                    .environmentObject(appViewModel)
                    .environmentObject(gadgetViewModel)
            }
        }
    }
}
