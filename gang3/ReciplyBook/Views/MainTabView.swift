import SwiftUI

struct MainTabView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var categoryViewModel = CategoryViewModel()
    @State private var selectedTab = 0
    @State private var showingRecipeDetail = false
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridOverlay()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        EnhancedRecipesListView(selectedTab: $selectedTab)
                            .environmentObject(recipeViewModel)
                            .environmentObject(categoryViewModel)
                    case 1:
                        AddRecipeTabView(selectedTab: $selectedTab)
                            .environmentObject(recipeViewModel)
                            .environmentObject(categoryViewModel)
                    case 2:
                        CategoriesView(categoryViewModel: categoryViewModel)
                    case 3:
                        CookingTipsView()
                    case 4:
                        SettingsView(selectedTab: $selectedTab)
                    default:
                        EnhancedRecipesListView(selectedTab: $selectedTab)
                            .environmentObject(recipeViewModel)
                            .environmentObject(categoryViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(
                recipe: recipe,
                recipeViewModel: recipeViewModel,
                categoryViewModel: categoryViewModel,
                selectedTab: $selectedTab
            )
        }
    }
}

struct AddRecipeTabView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        AddEditRecipeView(
            recipeViewModel: recipeViewModel,
            categoryViewModel: categoryViewModel,
            selectedTab: $selectedTab
        )
    }
}

struct EnhancedRecipesListView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var showingSortOptions = false
    @State private var showingMainMenu = false
    @State private var showingDeleteAllAlert = false
    @State private var showingCategoriesView = false
    @State private var showingCookingTipsView = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridOverlay()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if recipeViewModel.filteredRecipes.isEmpty {
                    emptyStateView
                } else {
                    recipesListContent
                }
            }
        }
        .sheet(isPresented: $recipeViewModel.showingAddRecipe) {
            AddEditRecipeView(recipeViewModel: recipeViewModel, categoryViewModel: categoryViewModel, selectedTab: $selectedTab)
        }
        .sheet(isPresented: $showingSortOptions) {
            sortOptionsSheet
        }
        .sheet(isPresented: $showingCategoriesView) {
            CategoriesView(categoryViewModel: categoryViewModel)
        }
        .sheet(isPresented: $showingCookingTipsView) {
            CookingTipsView()
        }
        .confirmationDialog("Menu", isPresented: $showingMainMenu) {
            Button("Categories") {
                withAnimation {
                    selectedTab = 2
                }
            }
            Button("Cooking Tips") {
                withAnimation {
                    selectedTab = 3
                }
            }
            Button("Delete All Recipes", role: .destructive) {
                showingDeleteAllAlert = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Delete All Recipes", isPresented: $showingDeleteAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                recipeViewModel.deleteAllRecipes()
            }
        } message: {
            Text("Are you sure you want to delete all saved recipes?")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Recipes")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
            
            HStack(spacing: 15) {                
                Button(action: {
                    showingMainMenu = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryYellow)
                        .frame(width: 40, height: 40)
                        .background(AppColors.primaryBlue.opacity(0.1))
                        .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            TextField("Find by recipe name...", text: $recipeViewModel.searchText)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.darkGray)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(AppColors.backgroundWhite)
        .cornerRadius(25)
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.bottom, 15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 15) {
                Text(recipeViewModel.searchText.isEmpty ? "No recipes yet" : "No matches found")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                
                Text(recipeViewModel.searchText.isEmpty ? "Add your first trusted recipe" : "Try a different search term")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            if recipeViewModel.searchText.isEmpty {
                Button(action: {
                    withAnimation {
                        selectedTab = 1
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Recipe")
                    }
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(25)
                    .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var recipesListContent: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(recipeViewModel.filteredRecipes) { recipe in
                        EnhancedRecipeCardView(
                            recipe: recipe,
                            recipeViewModel: recipeViewModel,
                            categoryViewModel: categoryViewModel,
                            selectedTab: $selectedTab
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 200)
            }
            .padding(.bottom, -100)
            
            Button(action: {
                showingSortOptions = true
            }) {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Sort")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryBlue)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(AppColors.backgroundWhite)
                .cornerRadius(20)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding(.bottom, 20)
        }
    }
    
    private var sortOptionsSheet: some View {
        VStack(spacing: 0) {
            Text("Sort Options")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
                .padding(.top, 20)
                .padding(.bottom, 30)
            
            VStack(spacing: 15) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        recipeViewModel.sortOption = option
                        showingSortOptions = false
                    }) {
                        HStack {
                            Text(option.rawValue)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.darkGray)
                            
                            Spacer()
                            
                            if recipeViewModel.sortOption == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(AppColors.primaryYellow)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(AppColors.backgroundWhite)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(AppColors.lightGray)
        .presentationDetents([.medium])
    }
    
}

struct EnhancedRecipeCardView: View {
    let recipe: Recipe
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Binding var selectedTab: Int
    
    @State private var showingActionSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingRecipeDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                        .lineLimit(2)
                    
                    if !recipe.category.isEmpty {
                        Text("Category: \(recipe.category)")
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.darkGray.opacity(0.8))
                    }
                    
                    if let cookingTime = recipe.cookingTime {
                        Text("Time: \(cookingTime) min")
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.darkGray.opacity(0.8))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showingActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(AppColors.primaryYellow)
                        .frame(width: 30, height: 30)
                        .background(AppColors.primaryBlue.opacity(0.1))
                        .cornerRadius(15)
                }
                .confirmationDialog(recipe.name, isPresented: $showingActionSheet) {
                    Button("Edit") {
                        recipeViewModel.selectedRecipe = recipe
                        recipeViewModel.showingAddRecipe = true
                    }
                    Button("Delete", role: .destructive) {
                        showingDeleteAlert = true
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        .onTapGesture {
            showingRecipeDetail = true
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                recipeViewModel.deleteRecipe(recipe)
            }
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
        .sheet(isPresented: $showingRecipeDetail) {
            RecipeDetailView(
                recipe: recipe,
                recipeViewModel: recipeViewModel,
                categoryViewModel: categoryViewModel,
                selectedTab: $selectedTab
            )
        }
    }
}

#Preview {
    MainTabView()
}
