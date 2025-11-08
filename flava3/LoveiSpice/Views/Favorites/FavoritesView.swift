import SwiftUI

struct FavoritesView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var searchText = ""
    @State private var selectedCategory: RecipeCategory? = nil
    @State private var selectedRecipe: Recipe?
    
    private var filteredRecipes: [Recipe] {
        var recipes = recipeViewModel.favoriteRecipes
        
        if !searchText.isEmpty {
            recipes = recipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let category = selectedCategory {
            recipes = recipes.filter { $0.category == category }
        }
        
        return recipes
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.ubuntuTitle)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                }
                .padding()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textSecondary)
                    
                    TextField("Search favorite recipes...", text: $searchText)
                        .font(.ubuntuBody)
                        .foregroundColor(.textPrimary)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {
                            selectedCategory = nil
                        }) {
                            Text("All")
                                .font(.ubuntuCaption)
                                .foregroundColor(selectedCategory == nil ? .white : .textSecondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedCategory == nil ? 
                                    Color.primaryPurple : Color.white.opacity(0.1)
                                )
                                .cornerRadius(20)
                        }
                        
                        ForEach(RecipeCategory.allCases, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category.displayName)
                                    .font(.ubuntuCaption)
                                    .foregroundColor(selectedCategory == category ? .white : .textSecondary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedCategory == category ? 
                                        Color.primaryPurple : Color.white.opacity(0.1)
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 15)
                
                if filteredRecipes.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text(searchText.isEmpty ? "No favorite recipes" : "Recipes not found")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textPrimary)
                        
                        Text(searchText.isEmpty ? 
                             "Add recipes to favorites to see them here" :
                                "Try changing your search query")
                        .font(.ubuntuBody)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRecipes) { recipe in
                                FavoritesRecipeCard(recipe: recipe, viewModel: recipeViewModel) {
                                    selectedRecipe = recipe
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipeId: recipe.id, viewModel: recipeViewModel)
        }
    }
}

struct FavoritesRecipeCard: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeViewModel
    
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryPurple.opacity(0.3), Color.primaryBlue.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "book.closed")
                        .font(.system(size: 30))
                        .foregroundColor(.primaryPurple)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Text(recipe.title)
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                viewModel.toggleFavorite(for: recipe)
                            }
                        }) {
                            Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(recipe.isFavorite ? .red : .textSecondary)
                                .font(.system(size: 16))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Text(recipe.category.displayName)
                        .font(.ubuntuCaption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.primaryPurple.opacity(0.2))
                        .cornerRadius(8)
                    
                    HStack {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                        
                        Text("\(recipe.ingredients.count) ingredients")
                            .font(.ubuntuSmall)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                    
                    Text(recipe.createdAt, style: .date)
                        .font(.ubuntuSmall)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
}
