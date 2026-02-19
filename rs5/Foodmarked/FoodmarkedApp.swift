import SwiftUI

@main
struct FoodmarkedApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var productStore = ProductStore()
    @StateObject private var achievementManager = AchievementManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                ZStack {
                    if !hasCompletedOnboarding {
                        OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                            .environmentObject(productStore)
                            .environmentObject(achievementManager)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .environmentObject(productStore)
                                .environmentObject(achievementManager)
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
        }
    }
}
