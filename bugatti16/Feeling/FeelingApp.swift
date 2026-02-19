import SwiftUI
import HookEther_Knowledge_Base

@main
struct FeelingApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var viewModel = MoodViewModel()
    @State private var showSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                ZStack {
                    if !viewModel.hasCompletedOnboarding {
                        OnboardingView(onComplete: {
                            viewModel.completeOnboarding()
                        })
                        .environmentObject(viewModel)
                        .transition(.slide)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .environmentObject(viewModel)
                                .transition(.opacity)
                                .navigationBarHidden(true)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
            }
        }
    }
}
