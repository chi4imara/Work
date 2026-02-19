import SwiftUI

struct MainTabView: View {
    @StateObject private var practiceViewModel = PracticeViewModel()
    @State private var selectedTab: TabItem = .today
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .today:
                    TodayView(practiceViewModel: practiceViewModel)
                case .practices:
                    MyPracticesView(practiceViewModel: practiceViewModel)
                case .history:
                    HistoryView(
                        practiceViewModel: practiceViewModel,
                        onNavigateToToday: { selectedTab = .today }
                    )
                case .statistics:
                    StatisticsView(practiceViewModel: practiceViewModel)
                case .settings:
                    SettingsView(practiceViewModel: practiceViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
