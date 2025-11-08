import SwiftUI

struct MainTabView: View {
    @StateObject private var tasksViewModel = TasksViewModel()
    @StateObject private var statisticsViewModel = StatisticsViewModel()
    
    var body: some View {
        TabView {
            RandomTaskView(tasksViewModel: tasksViewModel)
                .tabItem {
                    Image(systemName: "dice")
                    Text("Task")
                }
                .tag(0)
            
            CategoriesView(tasksViewModel: tasksViewModel)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Categories")
                }
                .tag(1)
            
            StatisticsView(
                statisticsViewModel: statisticsViewModel,
                tasksViewModel: tasksViewModel
            )
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Statistics")
            }
            .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(Color.theme.accentOrange)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color.theme.cardBackground)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.theme.secondaryText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.secondaryText),
            .font: UIFont(name: "Nunito-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.theme.accentOrange)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.accentOrange),
            .font: UIFont(name: "Nunito-SemiBold", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
