import SwiftUI

struct RecipeDetailView: View {
    let recipeId: UUID
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var recipe: Recipe? {
        viewModel.recipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        Group {
            if let currentRecipe = recipe {
                recipeDetailContent(recipe: currentRecipe)
            } else {
                Text("Recipe not found")
                    .foregroundColor(ColorManager.primaryText)
            }
        }
    }
    
    private func recipeDetailContent(recipe: Recipe) -> some View {
        let currentRecipe = recipe
        
        return ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(ColorManager.accent)
                        }
                        
                        Spacer()
                        
                        Text(currentRecipe.name.count > 20 ? String(currentRecipe.name.prefix(20)) + "..." : currentRecipe.name)
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Color.clear
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    VStack(spacing: 16) {
                        DetailSectionView(title: "Recipe Name") {
                            Text(currentRecipe.name)
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                        }
                        
                        HStack(spacing: 16) {
                            DetailSectionView(title: "Category") {
                                Text(currentRecipe.category.displayName)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.accent)
                            }
                            
                            DetailSectionView(title: "Created") {
                                Text(currentRecipe.formattedDate)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                        }
                        
                        if !currentRecipe.ingredients.isEmpty {
                            DetailSectionView(title: "Ingredients") {
                                Text(currentRecipe.ingredients)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                            }
                        }
                        
                        if !currentRecipe.proportions.isEmpty {
                            DetailSectionView(title: "Proportions / Formula") {
                                Text(currentRecipe.proportions)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                            }
                        }
                        
                        if !currentRecipe.process.isEmpty {
                            DetailSectionView(title: "Preparation Process") {
                                Text(currentRecipe.process)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                            }
                        }
                        
                        DetailSectionView(title: "Notes") {
                            Text(currentRecipe.notes.isEmpty ? "No notes available" : currentRecipe.notes)
                                .font(.ubuntu(16))
                                .foregroundColor(currentRecipe.notes.isEmpty ? ColorManager.secondaryText : ColorManager.primaryText)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.toggleFavorite(currentRecipe)
                        }) {
                            HStack {
                                Image(systemName: currentRecipe.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text(currentRecipe.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(currentRecipe.isFavorite ? ColorManager.yellow : ColorManager.accent)
                            )
                        }
                        
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("Edit Recipe")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorManager.buttonBackground)
                            )
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("Delete Recipe")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.red.opacity(0.5), lineWidth: 1)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.red.opacity(0.1))
                                    }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditRecipeView(recipeId: recipeId, viewModel: viewModel)
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let recipeToDelete = self.recipe {
                    viewModel.deleteRecipe(recipeToDelete)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this recipe? This action cannot be undone.")
        }
    }
}

struct DetailSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorManager.accent)
            
            content
                .frame(maxWidth: .infinity, alignment: .leading)
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
    let sampleRecipe = Recipe(
        name: "Honey Sugar Scrub",
        category: .scrubs,
        ingredients: "Honey\nSugar\nOlive oil",
        proportions: "2 tbsp honey, 1 cup sugar, 1 tbsp oil",
        process: "Mix all ingredients together until well combined.",
        notes: "Great for dry skin"
    )
    viewModel.addRecipe(sampleRecipe)
    
    return RecipeDetailView(recipeId: sampleRecipe.id, viewModel: viewModel)
}
