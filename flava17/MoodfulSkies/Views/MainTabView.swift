import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TodayView(selectedTab: $selectedTab)
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("Today")
            }
            .tag(0)
            
            NavigationStack {
                CalendarView()
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "calendar.circle.fill" : "calendar.circle")
                Text("Calendar")
            }
            .tag(1)
            
            NavigationStack {
                StatisticsView(selectedTab: $selectedTab)
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                Text("Statistics")
            }
            .tag(2)
            
            ProfileView()
            .tabItem {
                Image(systemName: selectedTab == 3 ? "person.circle.fill" : "person.circle")
                Text("Profile")
            }
            .tag(3)
        }
        .accentColor(appColors.primaryOrange)
        .onAppear {
            setupTabBarAppearance()
        }
        .onChange(of: appColors.selectedAccent) { _ in
            setupTabBarAppearance()
        }
        .onChange(of: appColors.selectedScheme) { _ in
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        switch appColors.selectedScheme {
        case .light:
            appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        case .dark:
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        case .auto:
            appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        }
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(appColors.primaryOrange)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(appColors.primaryOrange),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(appColors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(appColors.textSecondary),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.view.setNeedsLayout()
            }
        }
    }
}

#Preview {
    MainTabView()
}
