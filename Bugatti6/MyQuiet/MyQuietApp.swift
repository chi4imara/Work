import SwiftUI
import HookEther_Knowledge_Base

@main
struct MyQuietApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var viewModel = PrinciplesViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                AppRootView()
                    .environmentObject(viewModel)
            }
        }
    }
}

struct AppRootView: View {
    @EnvironmentObject var viewModel: PrinciplesViewModel
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "Onboarding")
    
    var body: some View {
        ZStack {
            if !showOnboarding {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.completeOnboarding()
                        showOnboarding = true
                        UserDefaults.standard.set(true, forKey: "Onboarding")
                    }
                }
            } else {
                NavigationStack {
                    MainTabView()
                        .environmentObject(viewModel)
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
    }
}
