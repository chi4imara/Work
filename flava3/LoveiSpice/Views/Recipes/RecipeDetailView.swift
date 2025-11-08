import SwiftUI

struct RecipeDetailView: View {
    let recipeId: UUID
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var recipe: Recipe? {
        viewModel.recipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                if let recipe = recipe {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(recipe.title)
                                .font(.ubuntuTitle)
                                .foregroundColor(.textPrimary)
                            
                            Text(recipe.category.displayName)
                                .font(.ubuntuSubheadline)
                                .foregroundColor(.textSecondary)
                        
                        if !recipe.ingredients.isEmpty {
                            Divider()
                                .overlay {
                                    Color.white
                                }
                                .padding(.horizontal, -20)
                                .frame(maxWidth: .infinity)
                            
                            Text("Ingredients")
                                .font(.ubuntuHeadline)
                                .foregroundColor(.textPrimary)
                            
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                IngredientRow(
                                    ingredient: ingredient,
                                    isUsed: viewModel.isIngredientUsed(recipeId: recipe.id, ingredient: ingredient)
                                ) {
                                    viewModel.toggleIngredientState(for: recipe.id, ingredient: ingredient)
                                }
                            }
                        }
                        
                        if !recipe.instructions.isEmpty {
                            Divider()
                                .overlay {
                                    Color.white
                                }
                                .padding(.horizontal, -20)
                                .frame(maxWidth: .infinity)
                            
                            Text("Instructions")
                                .font(.ubuntuHeadline)
                                .foregroundColor(.textPrimary)
                            
                            Text(recipe.instructions)
                                .font(.ubuntuBody)
                                .foregroundColor(.textSecondary)
                                .lineSpacing(4)
                        }
                        
                            Spacer(minLength: 100)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text("Recipe not found")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textPrimary)
                        
                        Text("This recipe may have been deleted")
                            .font(.ubuntuBody)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Recipe Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let recipe = recipe {
                        HStack(spacing: 16) {
                            Button(action: {
                                viewModel.toggleFavorite(for: recipe)
                            }) {
                                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(recipe.isFavorite ? .red : .textPrimary)
                                    .font(.system(size: 18))
                            }
                            
                            Menu {
                                Button("Edit") {
                                    showingEditView = true
                                }
                                Button("Delete", role: .destructive) {
                                    showingDeleteAlert = true
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.textPrimary)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let recipe = recipe {
                AddEditRecipeView(viewModel: viewModel, editingRecipe: recipe)
            }
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let recipe = recipe {
                    viewModel.deleteRecipe(recipe)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
    }
}

struct IngredientRow: View {
    let ingredient: String
    let isUsed: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isUsed ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20))
                    .foregroundColor(isUsed ? .accentGreen : .textSecondary)
                
                Text(ingredient)
                    .font(.ubuntuBody)
                    .foregroundColor(isUsed ? .textTertiary : .textSecondary)
                    .strikethrough(isUsed)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleRecipe = Recipe(
        title: "Lentil Soup",
        category: .soups,
        ingredients: ["Lentils", "Carrots", "Onions", "Garlic"],
        instructions: "1. Heat oil in a large pot\n2. Add onions and cook until soft\n3. Add carrots and garlic\n4. Add lentils and water\n5. Simmer for 30 minutes"
    )
    let viewModel = RecipeViewModel()
    viewModel.addRecipe(sampleRecipe)
    
    return RecipeDetailView(
        recipeId: sampleRecipe.id,
        viewModel: viewModel
    )
}
