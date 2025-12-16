import SwiftUI

struct RecipeDetailView: View {
    let recipeId: UUID
    @EnvironmentObject var recipeManager: RecipeManager
    @Environment(\.dismiss) private var dismiss
    @State private var showEditView = false
    
    private var recipe: Recipe? {
        recipeManager.getRecipe(by: recipeId)
    }
    
    private var checkedIngredients: Set<UUID> {
        recipeManager.getCheckedIngredients(for: recipeId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundPrimary
                    .ignoresSafeArea()
                
                if let recipe = recipe {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            RecipeImageView(recipe: recipe)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                RecipeInfoView(recipe: recipe)
                                
                                IngredientsSection(
                                    ingredients: recipe.ingredients,
                                    checkedIngredients: checkedIngredients,
                                    recipeId: recipeId
                                )
                                .environmentObject(recipeManager)
                                
                                InstructionsSection(instructions: recipe.instructions)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .navigationTitle(recipe.name)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.textPrimary)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button(action: {
                                    showEditView = true
                                }) {
                                    Label("Edit Recipe", systemImage: "pencil")
                                }
                                
                                Divider()
                                
                                Button(action: {
                                    recipeManager.toggleFavorite(recipe)
                                }) {
                                    Label(
                                        recipeManager.isFavorite(recipe) ? "Remove from Favorites" : "Add to Favorites",
                                        systemImage: recipeManager.isFavorite(recipe) ? "star.slash" : "star"
                                    )
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(AppColors.textPrimary)
                            }
                        }
                    }
                    .sheet(isPresented: $showEditView) {
                        if let recipe = recipeManager.getRecipe(by: recipeId) {
                            EditRecipeView(recipe: recipe)
                                .environmentObject(recipeManager)
                        }
                    }
                } else {
                    VStack {
                        Text("Recipe not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .navigationTitle("Recipe")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }
            }
        }
    }
}
