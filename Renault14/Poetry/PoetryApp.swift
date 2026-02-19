import SwiftUI
import AquaLogic

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus
    @State private var showSplash = true
    @State private var onboardingDone: Bool = UserDefaults.standard.bool(forKey: "OnDone")
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashScreenView(showSplash: $showSplash)) {
                if !onboardingDone {
                    OnboardingView(onboardingDone: $onboardingDone)
                } else {
                    MainTabView()
                }
            }
        }
    }
}
