import SwiftUI

struct MainTabView: View {
    @StateObject private var eventStore = EventStore()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventsView(eventStore: eventStore)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "calendar.circle.fill" : "calendar.circle")
                        .font(.system(size: 20))
                    Text("Events")
                        .font(AppFonts.caption(12))
                }
                .tag(0)
            
            CalendarView(eventStore: eventStore)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "calendar.badge" : "calendar")
                        .font(.system(size: 20))
                    Text("Calendar")
                        .font(AppFonts.caption(12))
                }
                .tag(1)
            
            SearchView(eventStore: eventStore)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                        .font(.system(size: 20))
                    Text("Search")
                        .font(AppFonts.caption(12))
                }
                .tag(2)
            
            StatisticsView(eventStore: eventStore)
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                        .font(.system(size: 20))
                    Text("Statistics")
                        .font(AppFonts.caption(12))
                }
                .tag(3)
            
            SettingsView(eventStore: eventStore)
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                        .font(.system(size: 20))
                    Text("Settings")
                        .font(AppFonts.caption(12))
                }
                .tag(4)
        }
        .accentColor(AppColors.primaryYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = UIColor(AppColors.primaryBlue.opacity(0.9))
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primaryYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primaryYellow),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.appearance().layer.shadowColor = UIColor.black.cgColor
        UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: -2)
        UITabBar.appearance().layer.shadowRadius = 8
        UITabBar.appearance().layer.shadowOpacity = 0.3
    }
}
