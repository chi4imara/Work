import SwiftUI

@main
struct KeyWordApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                ContentView()
                    .environmentObject(appViewModel)
            }
        }
    }
}
