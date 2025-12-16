import SwiftUI

struct MainTabView: View {
    @StateObject private var sharedViewModel = WordsViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WordsListView(viewModel: sharedViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            CategoriesView(viewModel: sharedViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "folder.fill" : "folder")
                    Text("Categories")
                }
                .tag(1)
            
            AddWordTabView(viewModel: sharedViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "plus.circle.fill" : "plus.circle")
                    Text("Add")
                }
                .tag(2)
            
            StatisticsView(viewModel: sharedViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.pie.fill" : "chart.pie")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(Color.theme.primaryBlue)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.theme.textGray)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.textGray),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.theme.primaryBlue)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.primaryBlue),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct AddWordTabView: View {
    @ObservedObject var viewModel: WordsViewModel
    @Binding var selectedTab: Int
    
    init(viewModel: WordsViewModel, selectedTab: Binding<Int>) {
        self.viewModel = viewModel
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationView {
            AddEditWordView(
                viewModel: viewModel,
                onSave: {
                    selectedTab = 0
                },
                onCancel: {
                    selectedTab = 0
                },
                wrapInNavigationView: false
            )
        }
    }
}

#Preview {
    MainTabView()
}
