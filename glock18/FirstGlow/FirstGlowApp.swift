import SwiftUI
import LibSync

@main
struct FirstGlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontInitializer.initializeFonts()
        FontManager.registerFonts()
        FontManager.checkFontAvailability()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                ContentView()
                    .preferredColorScheme(.light)
            }
        }
    }
}
