import SwiftUI
import UIKit

@main
struct AtelierApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus: NeuralNexus
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashScreen()) {
                RootView()
            }
        }
    }
}
