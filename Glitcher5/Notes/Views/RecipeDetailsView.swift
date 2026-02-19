import SwiftUI

struct RecipeDetailsView: View {
    @Environment(\.dismiss) var dismiss
    let recipeId: UUID
    @ObservedObject var recipeViewModel: RecipeViewModel
    
    @State private var editRecipeId: UUID?
    @State private var showDeleteAlert = false
    
    private var recipe: Recipe? {
        recipeViewModel.recipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        Group {
            if let currentRecipe = recipe {
                recipeDetailsBody(recipe: currentRecipe)
            }
        }
        .onChange(of: recipeViewModel.recipes) { _ in
        }
    }
    
    @ViewBuilder
    private func recipeDetailsBody(recipe: Recipe) -> some View {
        
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Button("Close") {
                                dismiss()
                            }
                            .font(.playfairDisplay(size: 16, weight: .medium))
                            .foregroundColor(ColorManager.lightBlue)
                            
                            Spacer()
                            
                            Text(self.recipe?.dishName ?? recipe.dishName)
                                .font(.playfairDisplay(size: 24, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            Text("Close")
                                .font(.playfairDisplay(size: 16, weight: .medium))
                                .foregroundColor(Color.clear)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        if let currentRecipe = self.recipe {
                            VStack(spacing: 20) {
                                RecipeDetailSection(title: "Meat Type", value: currentRecipe.meatType, icon: "tag.fill")
                                RecipeDetailSection(title: "Cooking Time", value: "\(currentRecipe.cookingTime) min", icon: "clock.fill")
                                RecipeDetailSection(title: "Sauce / Marinade", value: currentRecipe.sauceMarinate, icon: "drop.fill")
                                RecipeDetailSection(title: "Cooking Step", value: currentRecipe.cookingStep, icon: "list.bullet")
                                RecipeDetailSection(
                                    title: "Comment",
                                    value: currentRecipe.comment.isEmpty ? "No comment added." : currentRecipe.comment,
                                    icon: "text.bubble.fill"
                                )
                            }
                            .padding(.horizontal, 20)
                        } else {
                            VStack(spacing: 20) {
                                RecipeDetailSection(title: "Meat Type", value: recipe.meatType, icon: "tag.fill")
                                RecipeDetailSection(title: "Cooking Time", value: "\(recipe.cookingTime) min", icon: "clock.fill")
                                RecipeDetailSection(title: "Sauce / Marinade", value: recipe.sauceMarinate, icon: "drop.fill")
                                RecipeDetailSection(title: "Cooking Step", value: recipe.cookingStep, icon: "list.bullet")
                                RecipeDetailSection(
                                    title: "Comment",
                                    value: recipe.comment.isEmpty ? "No comment added." : recipe.comment,
                                    icon: "text.bubble.fill"
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                if let currentRecipe = self.recipe {
                                    recipeViewModel.toggleFavorite(currentRecipe)
                                } else {
                                    recipeViewModel.toggleFavorite(recipe)
                                }
                            }) {
                                HStack {
                                    Image(systemName: (self.recipe?.isFavorite ?? false) ? "heart.fill" : "heart")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text((self.recipe?.isFavorite ?? false) ? "Remove from Favorites" : "Add to Favorites")
                                        .font(.playfairDisplay(size: 16, weight: .semibold))
                                }
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill((self.recipe?.isFavorite ?? false) ? ColorManager.error.opacity(0.2) : ColorManager.orange.opacity(0.2))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke((self.recipe?.isFavorite ?? false) ? ColorManager.error : ColorManager.orange, lineWidth: 1)
                                        }
                                )
                            }
                            
                            Button(action: {
                                editRecipeId = recipe.id
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Edit Recipe")
                                        .font(.playfairDisplay(size: 16, weight: .semibold))
                                }
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ColorManager.lightBlue.opacity(0.2))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(ColorManager.lightBlue, lineWidth: 1)
                                        }
                                )
                            }
                            
                            Button(action: {
                                showDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Delete Recipe")
                                        .font(.playfairDisplay(size: 16, weight: .semibold))
                                }
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ColorManager.error.opacity(0.2))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(ColorManager.error, lineWidth: 1)
                                        }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: Binding(
            get: { editRecipeId != nil },
            set: { if !$0 { editRecipeId = nil } }
        )) {
            if let editRecipeId = editRecipeId {
                EditRecipeView(
                    recipeId: editRecipeId,
                    recipeViewModel: recipeViewModel
                )
            }
        }
        .alert("Delete Recipe", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let recipe = self.recipe {
                    recipeViewModel.deleteRecipe(recipe)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this recipe? This action cannot be undone.")
        }
    }
}

struct RecipeDetailSection: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(ColorManager.orange)
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.lightBlue)
            }
            
            Text(value)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(ColorManager.primaryText)
                .lineLimit(nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.secondaryBackground.opacity(0.6))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                }
        )
    }
}

#Preview {
    let recipe = Recipe(
        dishName: "Ribeye Steak",
        meatType: "Beef",
        cookingTime: "12",
        sauceMarinate: "Classic BBQ",
        cookingStep: "Grill on high heat for 2 minutes each side, then reduce heat and cook for additional 5 minutes per side for medium rare.",
        comment: "Best cooked medium rare. Let rest for 5 minutes before serving."
    )
    let vm = RecipeViewModel()
    vm.recipes = [recipe]
    return RecipeDetailsView(
        recipeId: recipe.id,
        recipeViewModel: vm
    )
}
