import SwiftUI

@main
struct buggi1App: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appState = AppStateViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}
