import SwiftUI
import LibSync

@main
struct M3App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ContentView()
                    .environmentObject(appViewModel)
                    .onAppear {
                        appViewModel.hideSplash()
                    }
            }
        }
    }
}
