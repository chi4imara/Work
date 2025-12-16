import SwiftUI
import LibSync

@main
struct TryGlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = BeautyProductViewModel()
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                Group {
                    if viewModel.showOnboarding {
                        OnboardingView(viewModel: viewModel)
                    } else {
                        MainAppView()
                    }
                }
            }
        }
    }
}
