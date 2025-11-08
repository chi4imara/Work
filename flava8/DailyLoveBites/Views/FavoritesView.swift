import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var viewModel = RecipeViewModel.shared
    @State private var selectedRecipe: Recipe?
    @State private var showingRecipeDetails = false
    
    var favoriteRecipes: [Recipe] {
        viewModel.recipes.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    if favoriteRecipes.isEmpty {
                        emptyStateView
                    } else {
                        favoritesListView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe, viewModel: viewModel)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Favorites")
                        .font(AppFonts.titleLarge)
                        .foregroundColor(.white)
                    
                    Text("\(favoriteRecipes.count) favorite recipe\(favoriteRecipes.count == 1 ? "" : "s")")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.errorRed)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(AppFonts.titleMedium)
                    .foregroundColor(.white)
                
                Text("Mark recipes as favorites to see them here")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(favoriteRecipes) { recipe in
                    FavoriteRecipeCard(recipe: recipe) { action in
                        handleRecipeAction(action, for: recipe)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func handleRecipeAction(_ action: RecipeCardAction, for recipe: Recipe) {
        switch action {
        case .tap:
            selectedRecipe = recipe
            showingRecipeDetails = true
        case .toggleFavorite:
            viewModel.toggleRecipeFavorite(recipe)
        case .edit:
            break
        case .delete:
            viewModel.deleteRecipe(recipe)
        }
    }
}

struct FavoriteRecipeCard: View {
    let recipe: Recipe
    let onAction: (RecipeCardAction) -> Void
    
    var body: some View {
        Button(action: { onAction(.tap) }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryPurple, Color.accentOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "book.closed")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.darkText)
                        .multilineTextAlignment(.leading)
                    
                    Text(recipe.metadataString)
                        .font(AppFonts.bodySmall)
                        .foregroundColor(.darkGray)
                    
                    if !recipe.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(recipe.tags.prefix(3), id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(AppFonts.caption)
                                        .foregroundColor(.primaryPurple)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.primaryPurple.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: { onAction(.toggleFavorite) }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.errorRed)
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    FavoritesView()
}
