import SwiftUI

struct MainTabView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        TabView(selection: $appViewModel.selectedTab) {
            TasksView()
                .environmentObject(appViewModel)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Tasks")
                }
                .tag(0)
            
            HabitsView()
                .environmentObject(appViewModel)
                .tabItem {
                    Image(systemName: "heart.circle")
                    Text("Habits")
                }
                .tag(1)
            
            ProgressView()
                .environmentObject(appViewModel)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(2)
            
            ProfileView()
                .environmentObject(appViewModel)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(3)
            
            SettingsView()
                .environmentObject(appViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.accentYellow)
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        appearance.selectionIndicatorTintColor = UIColor(AppColors.accentYellow)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.textSecondary),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.accentYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.accentYellow),
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
