import SwiftUI

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(NeuralNexus.self) var neuralNexus
    @StateObject private var viewModel = GroomingViewModel()
    @State private var onDone = UserDefaults.standard.bool(forKey: "OnDone")
    @State private var showSplash = true
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            StellarDrift(loader: SplashScreenView(isLoading: $showSplash)) {
                Group {
                    if !onDone {
                        OnboardingView(showMainApp: $onDone)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .navigationBarHidden(true)
                        }
                    }
                }
                .environmentObject(viewModel)
            }
        }
    }
}
