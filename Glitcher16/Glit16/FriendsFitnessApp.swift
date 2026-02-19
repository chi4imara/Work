import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade: AppFacade
    @StateObject private var appState = AppStateManager()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashScreen()) {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}
