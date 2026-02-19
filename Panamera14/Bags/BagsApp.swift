import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct BagsApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @StateObject private var bagStore = BagStore()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                ContentView()
                    .environmentObject(bagStore)
            }
        }
    }
}
