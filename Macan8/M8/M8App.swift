import SwiftUI
import LibSync

@main
struct M8App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ContentView()
                    .environmentObject(appState)
                    .onAppear {
                        appState.finishLoading()
                    }
            }
        }
    }
}
