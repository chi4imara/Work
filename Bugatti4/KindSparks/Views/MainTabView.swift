import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .people
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch selectedTab {
                case .people:
                    PeopleView()
                case .allIdeas:
                    AllIdeasView()
                case .calendar:
                    CalendarView()
                case .statistics:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
