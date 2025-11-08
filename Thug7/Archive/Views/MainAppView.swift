import SwiftUI

struct MainAppView: View {
    @State private var showSplash = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                OnboardingView(showOnboarding: $hasSeenOnboarding)
            } else {
                MainTabView()
            }
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PlacesListView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Places")
                }
                .tag(0)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "folder.fill" : "folder")
                    Text("Categories")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "gear.circle.fill" : "gear.circle")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(AppTheme.primaryBlue)
        .onAppear {
            FontHelper.printAvailableFonts()
            FontManager.shared.printRegisteredFonts()
            
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppTheme.textSecondary)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(AppTheme.textSecondary),
                .font: UIFont(name: AppTheme.poppinsRegular, size: 12) ?? UIFont.systemFont(ofSize: 12)
            ]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppTheme.primaryBlue)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(AppTheme.primaryBlue),
                .font: UIFont(name: AppTheme.poppinsMedium, size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
