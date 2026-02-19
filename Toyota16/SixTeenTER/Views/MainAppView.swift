import SwiftUI

struct MainAppView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            if appViewModel.isFirstLaunch {
                OnboardingView(appViewModel: appViewModel)
                    .transition(.slide)
            } else {
                MainTabView(appViewModel: appViewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplashScreen)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isFirstLaunch)
    }
}

struct MainTabView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch appViewModel.currentTab {
                case .today:
                    TodayView()
                case .tasks:
                    TasksListView()
                case .statistics:
                    StatisticsView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(appViewModel: appViewModel)
            }
        }
    }
}

#Preview {
    MainAppView()
}
