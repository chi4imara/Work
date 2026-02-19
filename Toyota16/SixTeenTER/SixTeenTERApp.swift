import SwiftUI
import AquaLogic

@main
struct SixTeenTERApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus: NeuralNexus
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashScreen()) {
                MainAppView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
