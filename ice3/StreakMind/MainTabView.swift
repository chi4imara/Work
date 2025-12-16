import SwiftUI

struct MainTabView: View {
    @StateObject private var habitStore = HabitStore()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyStreakView(habitStore: habitStore)
                .tabItem {
                    Image(systemName: "target")
                    Text("Streak")
                }
                .tag(0)
            
            TrophiesView(habitStore: habitStore, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Trophies")
                }
                .tag(1)
            
            ChronologyView(habitStore: habitStore)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
                .tag(2)
            
            CategoriesView(habitStore: habitStore)
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Categories")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.accentYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = UIColor(AppColors.primaryPurple.opacity(0.9))
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.accentYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.accentYellow),
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
