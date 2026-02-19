import SwiftUI
import HookEther_Knowledge_Base

@main
struct SlowHoursApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var appViewModel = AppViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreen()) {
                ZStack {
                    if !appViewModel.hasCompletedOnboarding {
                        OnboardingView(onComplete: { appViewModel.completeOnboarding() })
                            .transition(.opacity)
                    } else {
                        MainTabView()
                            .environmentObject(appViewModel)
                            .transition(.opacity)
                    }
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    appViewModel.saveData()
                }
            }
        }
    }
}
