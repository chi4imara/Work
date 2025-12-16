import SwiftUI

@main
struct DayprintDiaryApp: App {
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
        }
    }
}
