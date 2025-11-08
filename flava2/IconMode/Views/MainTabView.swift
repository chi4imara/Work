import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView(selectedTabFirst: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Today")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "calendar.circle.fill" : "calendar.circle")
                    Text("Calendar")
                }
                .tag(1)
            
            HistoryView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "doc.text.fill" : "doc.text")
                    Text("History")
                }
                .tag(2)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "star.fill" : "star")
                    Text("Favorites")
                }
                .tag(3)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "chart.bar.fill" : "chart.bar")
                    Text("Stats")
                }
                .tag(4)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 5 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(5)
        }
        .accentColor(AppColors.primary)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        appearance.selectionIndicatorTintColor = UIColor(AppColors.primary)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.textSecondary),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primary),
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]
        
        appearance.shadowColor = UIColor(AppColors.primary.opacity(0.1))
        appearance.shadowImage = UIImage()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
        .environmentObject(VictoryViewModel())
}
