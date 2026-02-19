import SwiftUI

struct MainContainerView: View {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    var body: some View {
        ZStack {
            if !appViewModel.showOnboarding {
                OnboardingView(appViewModel: appViewModel)
            } else if appViewModel.showRecipeSaved, let savedRecipe = appViewModel.savedRecipe {
                RecipeSavedView(recipe: savedRecipe, appViewModel: appViewModel)
            } else {
                MainTabView(appViewModel: appViewModel, recipeViewModel: recipeViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplash)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showOnboarding)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showRecipeSaved)
    }
}

struct MainTabView: View {
    @ObservedObject var appViewModel: AppViewModel
    @ObservedObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch appViewModel.selectedTab {
                case 0: NewRecipeView(recipeViewModel: recipeViewModel, appViewModel: appViewModel)
                case 1: RecipesListView(recipeViewModel: recipeViewModel)
                case 2: MeatTypesView(recipeViewModel: recipeViewModel)
                case 3: FavoritesView(recipeViewModel: recipeViewModel)
                case 4: SettingsView(appViewModel: appViewModel)
                default: NewRecipeView(recipeViewModel: recipeViewModel, appViewModel: appViewModel)
                }
            }
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appViewModel.selectedTab)
            }
        }
    }
}

#Preview {
    MainContainerView()
}
