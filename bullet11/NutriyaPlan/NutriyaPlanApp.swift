import SwiftUI
import LibSync

@main
struct NutriyaPlanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        _ = FontManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if appViewModel.showingOnboarding {
                        OnboardingView(appViewModel: appViewModel)
                    } else {
                        MainAppView()
                            .environmentObject(appViewModel)
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: appViewModel.showingSplash)
                .animation(.easeInOut(duration: 0.5), value: appViewModel.showingOnboarding)
            }
        }
    }
}
