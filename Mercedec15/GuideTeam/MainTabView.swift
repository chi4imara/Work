import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var spaListVM = SPAListViewModel()
    @StateObject private var bookingsVM = BookingsViewModel()
    @StateObject private var progressVM = ProgressViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SPAListView()
                .environmentObject(spaListVM)
                .environmentObject(bookingsVM)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            BookingsView()
                .environmentObject(bookingsVM)
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Bookings")
                }
                .tag(1)
            
            ProgressView()
                .environmentObject(bookingsVM)
                .environmentObject(progressVM)
                .environmentObject(profileVM)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(2)
            
            ProfileView()
                .environmentObject(profileVM)
                .environmentObject(progressVM)
                .environmentObject(spaListVM)
                .environmentObject(bookingsVM)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(ColorTheme.primaryPurple)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        
        appearance.selectionIndicatorTintColor = UIColor(ColorTheme.primaryPurple)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorTheme.primaryPurple)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.primaryPurple),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
