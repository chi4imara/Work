import SwiftUI

struct MainTabView: View {
    @StateObject private var conversationViewModel = ConversationViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ConversationJournalView(viewModel: conversationViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "book.fill" : "book")
                    Text("Journal")
                }
                .tag(0)
            
            SearchView(viewModel: conversationViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            CalendarView(viewModel: conversationViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "calendar.circle.fill" : "calendar")
                    Text("Calendar")
                }
                .tag(2)
            
            StatisticsView(viewModel: conversationViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView(viewModel: conversationViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.secondary)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = UIColor(AppColors.primary.opacity(0.9))
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.secondary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.secondary),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.textSecondary),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
