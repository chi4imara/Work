import SwiftUI
import AquaLogic

@main
struct NPrimeApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus
    @StateObject private var appState = AppState()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashView()) {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}
