import SwiftUI
import LibSync

@main
struct TailmateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var dataManager = DataManager.shared
    @State private var showingSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                if !dataManager.hasCompletedOnboarding {
                        OnboardingView()
                    } else {
                        MainTabView()
                    }
                }
            }
        }
    }
}
