import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.favoriteRecipes.isEmpty {
                    EmptyStateView(
                        title: "No favorites yet",
                        subtitle: "Add recipes to favorites to see them here",
                        systemImage: "heart"
                    )
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favoriteRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeId: recipe.id, viewModel: viewModel)) {
                                    FavoriteRecipeCardView(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
    }
}

struct FavoriteRecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                        .lineLimit(2)
                    
                    Text(recipe.category.displayName)
                        .font(.ubuntu(14))
                        .foregroundColor(ColorManager.accent)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(ColorManager.yellow)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            
            Text(recipe.formattedDate)
                .font(.ubuntu(12))
                .foregroundColor(ColorManager.secondaryText)
            
            if !recipe.shortIngredients.isEmpty {
                Text(recipe.shortIngredients)
                    .font(.ubuntu(14))
                    .foregroundColor(ColorManager.secondaryText)
                    .lineLimit(2)
            }
            
            if !recipe.notes.isEmpty {
                Text(recipe.notes)
                    .font(.ubuntu(12))
                    .foregroundColor(ColorManager.secondaryText)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardGradient)
        )
    }
}

#Preview {
    FavoritesView(viewModel: RecipeViewModel())
}
