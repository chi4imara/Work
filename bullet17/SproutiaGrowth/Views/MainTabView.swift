import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        StableTabView {
            TabView(selection: $selectedTab) {
            MyPlantsView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "leaf.fill" : "leaf")
                    Text("Plants")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "calendar" : "calendar")
                    Text("Calendar")
                }
                .tag(2)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(1)
            
            
            TipsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "lightbulb.fill" : "lightbulb")
                    Text("Tips")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
            }
            .accentColor(AppColors.primaryBlue)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DataManager.shared)
}
