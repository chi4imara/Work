import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var viewModel: RecipeViewModel = RecipeViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipesListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "book.closed")
                    Text("Recipes")
                }
                .tag(0)
            
            SearchView(recipeViewModel: viewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            FavoritesView(recipeViewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(2)
            
            ShoppingListView(recipeViewModel: viewModel)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Shopping")
                }
                .tag(3)
            
            ProfileView(recipeViewModel: viewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
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
        
        appearance.backgroundColor = UIColor(AppColors.primary.opacity(0.1))
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black.opacity(0.6))
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black.opacity(0.6)),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.secondary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.secondary),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
