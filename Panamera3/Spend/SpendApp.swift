import SwiftUI

@main
struct SpendApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @StateObject private var budgetViewModel = BudgetViewModel()
    @State private var showSplash = true
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashScreen()) {
                ZStack {
                    if budgetViewModel.isFirstLaunch && !budgetViewModel.hasCompletedOnboarding {
                        OnboardingView(budgetViewModel: budgetViewModel)
                    } else {
                        NavigationStack {
                            MainTabView()
                                .environmentObject(budgetViewModel)
                                .navigationBarHidden(true)
                        }
                    }
                }
                .preferredColorScheme(.light)
            }
        }
    }
}
