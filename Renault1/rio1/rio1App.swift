import SwiftUI

@main
struct rio1App: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appState = AppState()
    @StateObject private var store = AppDataStore()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                ContentView()
                    .environmentObject(appState)
                    .environmentObject(store)
                    .preferredColorScheme(.light)
            }
        }
    }
}
