import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .ideas
    
    var body: some View {
        TabView(selection: $selectedTab) {
            IdeasListView()
                .tabItem {
                    Image(systemName: selectedTab == .ideas ? "message.fill" : "message")
                    Text("Ideas")
                }
                .tag(TabItem.ideas)
            
            CalendarView()
                .tabItem {
                    Image(systemName: selectedTab == .calendar ? "calendar.circle.fill" : "calendar.circle")
                    Text("Calendar")
                }
                .tag(TabItem.calendar)
            
            MemoriesView()
                .tabItem {
                    Image(systemName: selectedTab == .memories ? "star.fill" : "star")
                    Text("Memories")
                }
                .tag(TabItem.memories)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == .statistics ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(TabItem.statistics)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == .settings ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(TabItem.settings)
        }
        .accentColor(AppColors.blueText)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.blueText)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.blueText),
            .font: UIFont(name: "PlayfairDisplay-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.lightText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.lightText),
            .font: UIFont(name: "PlayfairDisplay-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}


#Preview {
    MainTabView()
}
