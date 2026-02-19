import SwiftUI

@main
struct RitualsApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                RootView()
                    .environmentObject(appViewModel)
            }
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            Group {
                if appViewModel.isFirstLaunch {
                    OnboardingView()
                        .transition(.slide)
                } else {
                    MainTabView()
                        .transition(.slide)
                }
            }
            .environmentObject(appViewModel)
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplash)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isFirstLaunch)
    }
}
