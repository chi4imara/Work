import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var selectedRecipe: Recipe?
    @State private var recipeToEdit: Recipe?
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if recipeManager.favoriteRecipes.isEmpty {
                    EmptyStateView(
                        icon: "star",
                        title: "No Favorites Yet",
                        message: "You haven't saved any favorite recipes yet"
                    )
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(recipeManager.favoriteRecipes) { recipe in
                                RecipeCardView(recipe: recipe) {
                                    selectedRecipe = recipe
                                }
                                .contextMenu {
                                    Button {
                                        recipeToEdit = recipe
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    Divider()
                                    
                                    Button(role: .destructive) {
                                        recipeManager.removeFavorite(recipe)
                                    } label: {
                                        Label("Remove from Favorites", systemImage: "star.slash")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipeId: recipe.id)
                .environmentObject(recipeManager)
        }
        .sheet(item: $recipeToEdit) { recipe in
            EditRecipeView(recipe: recipe)
                .environmentObject(recipeManager)
        }
    }
}

struct RecipeCardView: View {
    let recipe: Recipe
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                RecipeThumbnailView(recipe: recipe)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(2)
                    
                    Text("\(recipe.category.rawValue) • \(recipe.cookingTime) min")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 8) {
                        Image(systemName: recipe.category.icon)
                            .font(.system(size: 12))
                            .foregroundColor(recipe.category.color)
                        
                        Text(recipe.difficulty.rawValue)
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding()
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FavoritesView()
        .environmentObject(RecipeManager())
}
