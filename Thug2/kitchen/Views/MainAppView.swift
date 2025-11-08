import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = InteriorIdeasViewModel()
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
        if viewModel.isFirstLaunch {
                OnboardingView(viewModel: viewModel)
                    .transition(.slide)
            } else {
                MainTabView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingSplash = false
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showingSplash)
        .animation(.easeInOut(duration: 0.5), value: viewModel.isFirstLaunch)
    }
}

struct MainTabView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            TabView(selection: $selectedTab) {
                CatalogView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        Text("Catalog")
                    }
                    .tag(0)
                
                FavoritesView(viewModel: viewModel, selectedTab: $selectedTab
                )
                    .tabItem {
                        Image(systemName: selectedTab == 1 ? "star.fill" : "star")
                        Text("Favorites")
                    }
                    .tag(1)
                
                StatisticsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                        Text("Statistics")
                    }
                    .tag(2)
                
                SettingsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .accentColor(AppColors.primaryOrange)
            .onAppear {
                setupTabBarAppearance()
            }
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(AppColors.cardBackground)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.secondaryText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.secondaryText),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primaryOrange)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primaryOrange),
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainAppView()
}
