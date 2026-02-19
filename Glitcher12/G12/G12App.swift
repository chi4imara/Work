import SwiftUI
import GSource

@main
struct G12App: App {
    @UIApplicationDelegateAdaptor(AppHelper.self) var appHelper
    @StateObject private var viewModel = ManicureViewModel()
    @State private var showSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TinyToss(loader: SplashScreen()) {
                ZStack {
                    if viewModel.showOnboarding {
                        OnboardingView(showOnboarding: $viewModel.showOnboarding)
                            .onDisappear {
                                viewModel.completeOnboarding()
                            }
                    } else {
                        NavigationStack {
                            MainTabView()
                                .environmentObject(viewModel)
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
        }
    }
}
