import SwiftUI
import LibSync

@main
struct BrushBookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                RootView()
            }
        }
    }
}

struct RootView: View {
    @AppStorage("OnboardingCompleted") private var isOnboardingCompleted = false
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
         if !isOnboardingCompleted {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showingSplash)
        .animation(.easeInOut(duration: 0.5), value: isOnboardingCompleted)
    }
}
