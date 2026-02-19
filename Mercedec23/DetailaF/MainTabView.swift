import SwiftUI

struct MainTabView: View {
    @StateObject private var accessoryViewModel = AccessoryViewModel()
    @StateObject private var collectionViewModel = CollectionViewModel()
    @StateObject private var progressViewModel = ProgressViewModel()
    @State private var selectedTab: TabItem = .home
    @State private var showingAddAccessory = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == .home ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(TabItem.home)
            
            CollectionView()
                .tabItem {
                    Image(systemName: selectedTab == .collection ? "heart.fill" : "heart")
                    Text("Collection")
                }
                .tag(TabItem.collection)
            
            Color.clear
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(TabItem.add)
                .onAppear {
                    if selectedTab == .add {
                        showingAddAccessory = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            selectedTab = .home
                        }
                    }
                }
            
            ProgressView()
                .tabItem {
                    Image(systemName: selectedTab == .progress ? "chart.bar.fill" : "chart.bar")
                    Text("Progress")
                }
                .tag(TabItem.progress)
            
            SettingsTabView()
                .tabItem {
                    Image(systemName: selectedTab == .settings ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(TabItem.settings)
        }
        .tint(AppColors.primaryYellow)
        .onAppear {
            setupTabBarAppearance()
        }
        .sheet(isPresented: $showingAddAccessory) {
            AddAccessoryView()
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == .add {
                showingAddAccessory = true
            }
        }
        .environmentObject(accessoryViewModel)
        .environmentObject(collectionViewModel)
        .environmentObject(progressViewModel)
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.darkGray)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.darkGray),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primaryYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primaryYellow),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case collection = "Collection"
    case add = "Add"
    case progress = "Progress"
    case profile = "Profile"
    case settings = "Settings"
}

#Preview {
    MainTabView()
}
