import SwiftUI
import GSource

@main
struct G10App: App {
    @UIApplicationDelegateAdaptor(AppHelper.self) var appHelper
    @StateObject private var viewModel = ShoppingViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            TinyToss(loader: SplashView()) {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}
