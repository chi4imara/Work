import SwiftUI
import AquaLogic

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus: NeuralNexus
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashView()) {
                AppCoordinator()
            }
        }
    }
}
