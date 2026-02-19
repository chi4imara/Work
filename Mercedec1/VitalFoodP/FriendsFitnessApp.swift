import SwiftUI

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appState = AppState()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}
