import SwiftUI

@main
struct IdealyPlApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    @StateObject private var ideasViewModel = IdeasViewModel()
    @State private var showSplash = true
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                ZStack {
                    if !ideasViewModel.showOnboarding {
                        OnboardingView(viewModel: ideasViewModel)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .environmentObject(ideasViewModel)
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
        }
    }
}
