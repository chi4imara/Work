import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .font(.system(size: 20))
                    Text("Today")
                        .font(AppFonts.playfairMedium(size: 12))
                }
                .tag(0)
            
            MyRitualsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "sparkles" : "sparkles")
                        .font(.system(size: 20))
                    Text("My Rituals")
                        .font(AppFonts.playfairMedium(size: 12))
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                        .font(.system(size: 20))
                    Text("Statistics")
                        .font(AppFonts.playfairMedium(size: 12))
                }
                .tag(2)
            
            HistoryView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "calendar.badge.clock" : "calendar")
                        .font(.system(size: 20))
                    Text("History")
                        .font(AppFonts.playfairMedium(size: 12))
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                        .font(.system(size: 20))
                    Text("Settings")
                        .font(AppFonts.playfairMedium(size: 12))
                }
                .tag(4)
        }
        .accentColor(AppColors.primary)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.background)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primary),
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
