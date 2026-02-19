import SwiftUI

@main
struct NotesApp: App {
    @UIApplicationDelegateAdaptor(AppHelper.self) var appHelper
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TinyToss(loader: SplashScreen()) {
                MainContainerView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
