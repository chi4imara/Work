import SwiftUI

struct RecipesView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State private var showingAddRecipe = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Recipes")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddRecipe = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(ColorManager.accent)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ColorManager.secondaryText)
                    
                    TextField("Search recipes", text: $viewModel.searchText)
                        .font(.ubuntu(16))
                        .foregroundColor(ColorManager.primaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorManager.cardBackground)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                if viewModel.filteredRecipes.isEmpty {
                    EmptyStateView(
                        title: "No recipes yet",
                        subtitle: "Add your first recipe to get started",
                        systemImage: "flask"
                    )
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeId: recipe.id, viewModel: viewModel)) {
                                    RecipeCardView(recipe: recipe)
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
        .sheet(isPresented: $showingAddRecipe) {
            AddRecipeView(viewModel: viewModel)
        }
    }
}

struct RecipeCardView: View {
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
                    if recipe.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundColor(ColorManager.yellow)
                    }
                    
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

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(ColorManager.accent.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(subtitle)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    RecipesView(viewModel: RecipeViewModel())
}
