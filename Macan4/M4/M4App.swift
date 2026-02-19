import SwiftUI
import LibSync

@main
struct M4App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    @StateObject private var viewModel = MakeupLookViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                ZStack {
                    if viewModel.isShowingOnboarding {
                        OnboardingView {
                            viewModel.completeOnboarding()
                            showingOnboarding = false
                        }
                    } else {
                        MainTabView()
                            .environmentObject(viewModel)
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showingSplash)
                .animation(.easeInOut(duration: 0.5), value: showingOnboarding)
            }
        }
    }
}
