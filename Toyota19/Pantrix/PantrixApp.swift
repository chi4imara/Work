import SwiftUI

@main
struct PantrixApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus: NeuralNexus
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashScreen()) {
                AppRootView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
