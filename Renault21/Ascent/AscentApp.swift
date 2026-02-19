import SwiftUI

@main
struct AscentApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus: NeuralNexus
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashView()) {
                ContentView()
                    .environmentObject(appViewModel)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
