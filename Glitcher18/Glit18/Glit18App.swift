import SwiftUI
import twoProtobuf_crypto_KIT

@main
struct Glit18App: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade: AppFacade
    
    init() {
        FontManager.shared.registerFonts()
        
        let navbar = UINavigationBarAppearance()
        navbar.configureWithOpaqueBackground()
        navbar.backgroundColor = .clear
        navbar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = navbar
        UINavigationBar.appearance().scrollEdgeAppearance = navbar
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                ContentView()
            }
        }
    }
}
