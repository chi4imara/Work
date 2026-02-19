import SwiftUI

struct MainTabView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch appState.currentTab {
                case .today:
                    TodayView(appState: appState)
                case .recipes:
                    MyRecipesView(appState: appState)
                case .history:
                    HistoryView(appState: appState)
                case .statistics:
                    StatisticsView(appState: appState)
                case .settings:
                    SettingsView(appState: appState)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.currentTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
