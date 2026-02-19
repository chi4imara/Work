import SwiftUI

struct MainTabView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    var body: some View {
        TabView {
            RecipesView(viewModel: recipeViewModel)
                .tabItem {
                    Image(systemName: "flask")
                    Text("Recipes")
                }
            
            CategoriesView(viewModel: recipeViewModel)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Categories")
                }
            
            FavoritesView(viewModel: recipeViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
            
            StatisticsView(viewModel: recipeViewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(ColorManager.accent)
    }
}


#Preview {
    MainTabView()
}
