import SwiftUI

struct RecipeDetailDestination: Identifiable {
    let id: UUID
}

struct RecipeDetailView: View {
    let recipeId: UUID
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingCookedAlert = false
    
    private var recipe: Recipe? {
        appState.recipe(by: recipeId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if let recipe = recipe {
                    recipeContent(recipe: recipe)
                } else {
                    recipeNotFoundContent
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.appWhite)
                }
                
                if recipe != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Edit Recipe") {
                                showingEditView = true
                            }
                            
                            Button("Delete Recipe", role: .destructive) {
                                showingDeleteAlert = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.appWhite)
                        }
                    }
                }
            }
            .toolbarBackground(Color.appDarkBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .sheet(isPresented: $showingEditView) {
            if let recipe = recipe {
                EditRecipeView(recipe: recipe, appState: appState)
            }
        }
        .alert("Recipe Cooked!", isPresented: $showingCookedAlert) {
            Button("Great!") { }
        } message: {
            Text("Excellent! Breakfast is ready. Enjoy your meal!")
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let recipe = recipe {
                    appState.deleteRecipe(recipe)
                }
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this recipe? This action cannot be undone.")
        }
    }
    
    private func recipeContent(recipe: Recipe) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.name)
                                .font(.appTitle)
                                .foregroundColor(.appWhite)
                            
                            HStack(spacing: 16) {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.appCallout)
                                        .foregroundColor(.appOrange)
                                    
                                    Text("\(recipe.cookingTime) minutes")
                                        .font(.appCallout)
                                        .foregroundColor(.appWhite)
                                }
                                
                                Text(recipe.category.displayName)
                                    .font(.appCallout)
                                    .foregroundColor(.appOrange)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.appOrange.opacity(0.2))
                                    .cornerRadius(12)
                                
                                Spacer()
                                
                                Button(action: {
                                    appState.toggleFavorite(for: recipe)
                                }) {
                                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                        .font(.appTitle3)
                                        .foregroundColor(recipe.isFavorite ? .appRed : .appWhite)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ingredients")
                                .font(.appTitle3)
                                .foregroundColor(.appWhite)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(recipe.ingredients.indices, id: \.self) { index in
                                    HStack(alignment: .top, spacing: 12) {
                                        Circle()
                                            .fill(Color.appOrange)
                                            .frame(width: 6, height: 6)
                                            .padding(.top, 6)
                                        
                                        Text(recipe.ingredients[index])
                                            .font(.appBody)
                                            .foregroundColor(.appWhite)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .padding(16)
                            .background(AppColors.cardGradient)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.appTitle3)
                                .foregroundColor(.appWhite)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(recipe.instructions.indices, id: \.self) { index in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(index + 1)")
                                            .font(.appHeadline)
                                            .foregroundColor(.appOrange)
                                            .frame(width: 24, height: 24)
                                            .background(Color.appOrange.opacity(0.2))
                                            .cornerRadius(12)
                                        
                                        Text(recipe.instructions[index])
                                            .font(.appBody)
                                            .foregroundColor(.appWhite)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .padding(16)
                            .background(AppColors.cardGradient)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            if recipe.isCooked {
                                appState.unmarkAsCooked(recipe)
                            } else {
                                appState.markAsCooked(recipe)
                                showingCookedAlert = true
                            }
                        }) {
                            HStack {
                                Image(systemName: recipe.isCooked ? "checkmark.circle.fill" : "circle")
                                    .font(.appHeadline)
                                
                                Text(recipe.isCooked ? "Cooked" : "I Cooked This!")
                                    .font(.appHeadline)
                            }
                            .foregroundColor(.appWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(recipe.isCooked ? Color.appGreen : Color.appWhite.opacity(0.2))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(recipe.isCooked ? Color.clear : Color.appGreen, lineWidth: 2)
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
    }
    
    private var recipeNotFoundContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundColor(.appWhite.opacity(0.5))
            
            Text("Recipe not found")
                .font(.appTitle3)
                .foregroundColor(.appWhite)
            
            Text("It may have been deleted.")
                .font(.appBody)
                .foregroundColor(.appWhite.opacity(0.7))
            
            Button("Close") {
                dismiss()
            }
            .font(.appHeadline)
            .foregroundColor(.appWhite)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.appOrange)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EditRecipeView: View {
    let recipe: Recipe
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var cookingTime: Int
    @State private var ingredients: [String]
    @State private var instructions: [String]
    @State private var selectedCategory: Recipe.RecipeCategory
    
    init(recipe: Recipe, appState: AppState) {
        self.recipe = recipe
        self.appState = appState
        self._name = State(initialValue: recipe.name)
        self._cookingTime = State(initialValue: recipe.cookingTime)
        self._ingredients = State(initialValue: recipe.ingredients)
        self._instructions = State(initialValue: recipe.instructions)
        self._selectedCategory = State(initialValue: recipe.category)
    }
    
    var isValid: Bool {
        !name.isEmpty &&
        cookingTime > 0 &&
        ingredients.contains { !$0.isEmpty } &&
        instructions.contains { !$0.isEmpty }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recipe Name")
                                .font(.appHeadline)
                                .foregroundColor(.appWhite)
                            
                            TextField("Enter recipe name", text: $name)
                                .font(.appBody)
                                .padding(16)
                                .background(Color.appWhite.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.appWhite)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cooking Time (minutes)")
                                .font(.appHeadline)
                                .foregroundColor(.appWhite)
                            
                            HStack {
                                Button(action: {
                                    if cookingTime > 1 {
                                        cookingTime -= 1
                                    }
                                }) {
                                    Image(systemName: "minus")
                                        .font(.appHeadline)
                                        .foregroundColor(.appWhite)
                                        .frame(width: 44, height: 44)
                                        .background(Color.appOrange.opacity(0.3))
                                        .cornerRadius(8)
                                }
                                
                                Text("\(cookingTime)")
                                    .font(.appTitle2)
                                    .foregroundColor(.appWhite)
                                    .frame(maxWidth: .infinity)
                                
                                Button(action: {
                                    cookingTime += 1
                                }) {
                                    Image(systemName: "plus")
                                        .font(.appHeadline)
                                        .foregroundColor(.appWhite)
                                        .frame(width: 44, height: 44)
                                        .background(Color.appOrange.opacity(0.3))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.appHeadline)
                                .foregroundColor(.appWhite)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(Recipe.RecipeCategory.allCases, id: \.self) { category in
                                        Button(action: {
                                            selectedCategory = category
                                        }) {
                                            Text(category.displayName)
                                                .font(.appCallout)
                                                .foregroundColor(selectedCategory == category ? .appWhite : .appWhite.opacity(0.7))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    selectedCategory == category ?
                                                    Color.appOrange : Color.appWhite.opacity(0.1)
                                                )
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Ingredients")
                                    .font(.appHeadline)
                                    .foregroundColor(.appWhite)
                                
                                Spacer()
                                
                                Button(action: addIngredient) {
                                    Image(systemName: "plus")
                                        .font(.appCallout)
                                        .foregroundColor(.appOrange)
                                }
                            }
                            
                            ForEach(ingredients.indices, id: \.self) { index in
                                HStack {
                                    TextField("Ingredient \(index + 1)", text: $ingredients[index])
                                        .font(.appBody)
                                        .padding(12)
                                        .background(Color.appWhite.opacity(0.1))
                                        .cornerRadius(8)
                                        .foregroundColor(.appWhite)
                                    
                                    if ingredients.count > 1 {
                                        Button(action: {
                                            removeIngredient(at: index)
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .font(.appCallout)
                                                .foregroundColor(.appRed)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Instructions")
                                    .font(.appHeadline)
                                    .foregroundColor(.appWhite)
                                
                                Spacer()
                                
                                Button(action: addInstruction) {
                                    Image(systemName: "plus")
                                        .font(.appCallout)
                                        .foregroundColor(.appOrange)
                                }
                            }
                            
                            ForEach(instructions.indices, id: \.self) { index in
                                HStack(alignment: .top) {
                                    Text("\(index + 1).")
                                        .font(.appCallout)
                                        .foregroundColor(.appOrange)
                                        .padding(.top, 12)
                                    
                                    TextField("Step \(index + 1)", text: $instructions[index], axis: .vertical)
                                        .font(.appBody)
                                        .padding(12)
                                        .background(Color.appWhite.opacity(0.1))
                                        .cornerRadius(8)
                                        .foregroundColor(.appWhite)
                                    
                                    if instructions.count > 1 {
                                        Button(action: {
                                            removeInstruction(at: index)
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .font(.appCallout)
                                                .foregroundColor(.appRed)
                                        }
                                        .padding(.top, 12)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.appWhite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .foregroundColor(isValid ? .appOrange : .appWhite.opacity(0.3))
                    .disabled(!isValid)
                }
            }
            .toolbarBackground(Color.appDarkBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private func addIngredient() {
        ingredients.append("")
    }
    
    private func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
    
    private func addInstruction() {
        instructions.append("")
    }
    
    private func removeInstruction(at index: Int) {
        instructions.remove(at: index)
    }
    
    private func saveRecipe() {
        let filteredIngredients = ingredients.filter { !$0.isEmpty }
        let filteredInstructions = instructions.filter { !$0.isEmpty }
        
        var updatedRecipe = recipe
        updatedRecipe.name = name
        updatedRecipe.cookingTime = cookingTime
        updatedRecipe.ingredients = filteredIngredients
        updatedRecipe.instructions = filteredInstructions
        updatedRecipe.category = selectedCategory
        
        appState.updateRecipe(updatedRecipe)
        dismiss()
    }
}

#Preview {
    let appState = AppState()
    let previewRecipe = Recipe(
        name: "Preview Recipe",
        cookingTime: 10,
        ingredients: ["Ingredient 1"],
        instructions: ["Step 1"],
        category: .quick
    )
    appState.recipes.append(previewRecipe)
    return RecipeDetailView(recipeId: previewRecipe.id, appState: appState)
}
