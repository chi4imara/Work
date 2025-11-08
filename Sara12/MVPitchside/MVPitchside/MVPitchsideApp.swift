import SwiftUI

@main
struct MVPitchsideApp: App {
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
    }
}
