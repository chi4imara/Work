import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HairstylesView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "scissors" : "scissors")
                    Text("Hairstyles")
                }
                .tag(0)
            
            LooksView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "photo.fill" : "photo")
                    Text("Looks")
                }
                .tag(1)
            
            HistoryView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "clock.fill" : "clock")
                    Text("History")
                }
                .tag(2)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
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
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor(AppColors.darkBlue.opacity(0.95))
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primaryYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primaryYellow),
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
        .environmentObject(HairstyleViewModel())
}
