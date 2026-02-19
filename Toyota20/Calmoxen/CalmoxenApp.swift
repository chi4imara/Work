import SwiftUI
import AquaLogic

@main
struct CalmoxenApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @State private var showSplash = true
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashScreen(isActive: $showSplash)) {
                ZStack {
                    if !onboardingViewModel.hasCompletedOnboarding {
                        OnboardingView(isCompleted: $onboardingViewModel.hasCompletedOnboarding)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .navigationBarHidden(true)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showSplash)
                .animation(.easeInOut(duration: 0.5), value: onboardingViewModel.hasCompletedOnboarding)
            }
        }
    }
}
