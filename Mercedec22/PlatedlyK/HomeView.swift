import SwiftUI

struct RecipeDetailItem: Identifiable {
    let id: UUID
}

struct HomeView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var showingFilters = false
    @State private var selectedRecipeId: RecipeDetailItem?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.2)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    
                    searchAndFiltersView
                    
                    if recipeViewModel.isLoading {
                        loadingView
                    } else if recipeViewModel.filteredRecipes.isEmpty {
                        emptyStateView
                    } else {
                        recipesGridView
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 180)
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(filters: $recipeViewModel.filters) {
                recipeViewModel.applyFilters()
            }
        }
        .sheet(item: $selectedRecipeId) { item in
            RecipeDetailView(
                recipeId: item.id,
                recipeProvider: { recipeViewModel.recipe(byId: $0) },
                onUpdate: { recipeViewModel.updateRecipe($0) }
            )
        }
        .onChange(of: recipeViewModel.searchText) { _ in
            recipeViewModel.applyFilters()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommended Today")
                        .font(AppFonts.title(28))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Choose a dish by taste and goal")
                        .font(AppFonts.subtitle(16))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
        }
    }
    
    private var searchAndFiltersView: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("Search recipes...", text: $recipeViewModel.searchText)
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textPrimary)
                
                if !recipeViewModel.searchText.isEmpty {
                    Button(action: { recipeViewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
            
            Button(action: { showingFilters = true }) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .fill(recipeViewModel.filters.isActive ? AppColors.primaryYellow : AppColors.cardBackground)
                        .frame(width: 50, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                    
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 18))
                        .foregroundColor(recipeViewModel.filters.isActive ? .black : AppColors.textPrimary)
                }
            }
        }
    }
    
    private var recipesGridView: some View {
        LazyVStack(spacing: 16) {
            ForEach(recipeViewModel.filteredRecipes) { recipe in
                RecipeCard(
                    recipe: recipe,
                    onLikeToggle: { recipeViewModel.toggleLike(for: recipe) },
                    onWishlistToggle: { recipeViewModel.toggleWishlist(for: recipe) },
                    onTap: { selectedRecipeId = RecipeDetailItem(id: recipe.id) }
                )
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(AppColors.primaryYellow)
            
            Text("Loading recipes...")
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(height: 200)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No suitable recipes")
                .font(AppFonts.subtitle(20))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Try adjusting your filters or search terms")
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                recipeViewModel.filters.reset()
                recipeViewModel.searchText = ""
                recipeViewModel.applyFilters()
            }) {
                Text("Reset Filters")
                    .font(AppFonts.button(16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                            .fill(AppColors.primaryYellow)
                    )
            }
        }
        .frame(height: 300)
    }
    
    private var refreshButton: some View {
        Button(action: { recipeViewModel.refreshRecipes() }) {
            HStack {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16))
                
                Text("Update Selection")
                    .font(AppFonts.button(16))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                    .fill(AppColors.primaryYellow)
            )
        }
        .disabled(recipeViewModel.isLoading)
        .opacity(recipeViewModel.isLoading ? 0.6 : 1.0)
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    let onLikeToggle: () -> Void
    let onWishlistToggle: () -> Void
    let onTap: () -> Void
    
    @State private var isPulsing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Text(recipe.name)
                    .font(AppFonts.subtitle(17))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer(minLength: 8)
            }
            
            HStack(spacing: 16) {
                Label("\(recipe.cookingTime) min", systemImage: "clock")
                Label("\(recipe.calories) kcal", systemImage: "flame")
                Spacer()
            }
            .font(AppFonts.caption(13))
            .foregroundColor(AppColors.textSecondary)
            
            HStack(spacing: 8) {
                Text(recipe.difficulty.rawValue)
                    .font(AppFonts.caption(11))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(difficultyColor(recipe.difficulty))
                    )
                
                Text(recipe.category.rawValue)
                    .font(AppFonts.caption(11))
                    .foregroundColor(AppColors.textAccent)
                
                Spacer()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
    
    private func difficultyColor(_ difficulty: Recipe.Difficulty) -> Color {
        switch difficulty {
        case .beginner:
            return AppColors.secondaryGreen
        case .intermediate:
            return AppColors.secondaryOrange
        case .advanced:
            return AppColors.secondaryPink
        }
    }
}

#Preview {
    HomeView(recipeViewModel: RecipeViewModel())
}
