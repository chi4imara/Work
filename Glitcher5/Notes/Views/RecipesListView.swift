import SwiftUI

struct RecipesListView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Recipe List")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.vertical, 10)
                
                if recipeViewModel.recipes.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text("You haven't added any recipes yet.")
                            .font(.playfairDisplay(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(recipeViewModel.recipes) { recipe in
                                RecipeListCard(recipe: recipe) {
                                    selectedRecipe = recipe
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailsView(
                recipeId: recipe.id,
                recipeViewModel: recipeViewModel
            )
        }
    }
}

struct RecipeListCard: View {
    let recipe: Recipe
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorManager.orange)
                }
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(ColorManager.orange.opacity(0.1))
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.dishName)
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                        .lineLimit(1)
                    
                    HStack(spacing: 12) {
                        Label(recipe.meatType, systemImage: "tag.fill")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(ColorManager.lightBlue)
                            .lineLimit(1)
                        
                        Label("\(recipe.cookingTime) min", systemImage: "clock.fill")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(ColorManager.secondaryText)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Text("Open")
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.lightBlue.opacity(0.2))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ColorManager.lightBlue, lineWidth: 1)
                            }
                    )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.secondaryBackground.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                    }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RecipesListView(recipeViewModel: {
        let vm = RecipeViewModel()
        vm.recipes = [
            Recipe(
                dishName: "Ribeye Steak",
                meatType: "Beef",
                cookingTime: "12",
                sauceMarinate: "Classic BBQ",
                cookingStep: "Grill on high heat",
                comment: "Medium rare"
            ),
            Recipe(
                dishName: "BBQ Wings",
                meatType: "Chicken",
                cookingTime: "25",
                sauceMarinate: "Honey Mustard",
                cookingStep: "Cook until crispy",
                comment: ""
            )
        ]
        return vm
    }())
}
