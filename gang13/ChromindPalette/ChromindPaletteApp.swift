import SwiftUI
import LibSync

@main
struct ChromindPaletteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataManager = DataManager.shared
    @State private var showSplash = true
    
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
                        TabBarView()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: showSplash)
                .animation(.easeInOut(duration: 0.5), value: dataManager.hasCompletedOnboarding)
            }
        }
    }
}
