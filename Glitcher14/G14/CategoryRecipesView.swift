import SwiftUI

struct CategoryRecipesView: View {
    let category: RecipeCategory
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var categoryRecipes: [Recipe] {
        viewModel.recipes(for: category)
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.accent)
                    }
                    
                    Spacer()
                    
                    Text(category.displayName)
                        .font(.ubuntu(20, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if categoryRecipes.isEmpty {
                    EmptyStateView(
                        title: "No recipes in this category",
                        subtitle: "Add recipes to see them here",
                        systemImage: "flask"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(categoryRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeId: recipe.id, viewModel: viewModel)) {
                                    CategoryRecipeCardView(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct CategoryRecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(recipe.name)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(2)
                
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

#Preview {
    let viewModel = RecipeViewModel()
    return CategoryRecipesView(category: .scrubs, viewModel: viewModel)
}
