import SwiftUI
import LibSync

@main
struct AuraLogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var store = PerfumeStore()
    @State private var showingSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                  if !store.hasSeenOnboarding {
                        OnboardingView(store: store)
                    } else {
                        MainTabView()
                            .environmentObject(store)
                    }
                }
            }
        }
    }
}
