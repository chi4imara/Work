import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct aromaApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @StateObject private var viewModel = FragranceViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}
