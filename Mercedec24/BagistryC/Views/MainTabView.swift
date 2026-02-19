import SwiftUI

struct MainTabView: View {
    @StateObject private var bagViewModel = BagViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                HomeView()
                    .environmentObject(bagViewModel)
                    .environmentObject(userViewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        Text("Home")
                    }
                    .tag(0)
                
                CollectionView()
                    .environmentObject(bagViewModel)
                    .environmentObject(userViewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 1 ? "heart.fill" : "heart")
                        Text("Collection")
                    }
                    .tag(1)
                
                UserProgressView()
                    .environmentObject(bagViewModel)
                    .environmentObject(userViewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                        Text("Progress")
                    }
                    .tag(2)
                
                ProfileView()
                    .environmentObject(userViewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                        Text("Profile")
                    }
                    .tag(3)
                
                SettingsView()
                    .environmentObject(bagViewModel)
                    .environmentObject(userViewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                        Text("Settings")
                    }
                    .tag(4)
            }
        }
        .accentColor(Color.theme.accentYellow)
        .onAppear {
            setupTabBarAppearance()
            userViewModel.setCollectionCount(bagViewModel.favoriteBags.count)
        }
        .onChange(of: bagViewModel.favoriteBags.count) { newCount in
            userViewModel.setCollectionCount(newCount)
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor(Color.theme.cardBackground)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.yellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.yellow),
            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
