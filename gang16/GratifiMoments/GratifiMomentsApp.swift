import SwiftUI

@main
struct GratifiMomentsApp: App {
    
    init() {
        _ =  FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
    }
}
