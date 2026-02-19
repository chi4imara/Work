import SwiftUI
import LibSync

@main
struct U9App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var productViewModel = ProductViewModel()
    @State private var showingSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if productViewModel.showingOnboarding {
                        OnboardingView(productViewModel: productViewModel)
                            .transition(.opacity)
                    } else {
                        MainTabView()
                            .environmentObject(productViewModel)
                            .transition(.opacity)
                    }
                }
            }
        }
    }
}
