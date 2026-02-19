import SwiftUI

struct MainAppView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            if appViewModel.appState.hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(appViewModel)
                    .transition(.opacity)
            } else {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appViewModel.completeOnboarding()
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
                .ignoresSafeArea()
            
            switch (appViewModel.appState.selectedTab) {
            case .today: TodayView()
            case .habits: HabitsListView()
            case .history: HistoryView()
            case .statistics: StatisticsView()
            case .settings: SettingsView()
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $appViewModel.appState.selectedTab)
            }
        }
    }
}

#Preview {
    MainAppView()
}
