import SwiftUI

struct MainTabView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        TabView(selection: $appViewModel.selectedTab) {
            TodayView()
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    Text("Today")
                }
                .tag(0)
            
            HabitsView()
                .tabItem {
                    Image(systemName: "list.bullet.circle.fill")
                    Text("My Habits")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.doc.horizontal")
                    Text("Statistics")
                }
                .tag(2)
            
            HistoryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(Theme.Colors.primary)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont(name: "PlayfairDisplay-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Theme.Colors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.Colors.textSecondary),
            .font: UIFont(name: "PlayfairDisplay-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
