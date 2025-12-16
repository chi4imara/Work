import SwiftUI

struct AddEditRecipeView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    @State private var recipeName = ""
    @State private var selectedCategory = ""
    @State private var cookingTimeText = ""
    @State private var ingredients = ""
    @State private var steps = ""
    @State private var notes = ""
    @State private var showingCustomCategory = false
    @State private var customCategoryName = ""
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    
    private var isEditing: Bool {
        recipeViewModel.selectedRecipe != nil
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridOverlay()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(isEditing ? "Edit Recipe" : "New Recipe")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveRecipe()
                        
                        withAnimation {
                            selectedTab = 0
                        }
                    }
                    .foregroundColor(AppColors.primaryYellow)
                    .disabled(recipeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recipe Name *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            TextField("e.g., Banana Pancakes", text: $recipeName)
                                .font(.ubuntu(16))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(AppColors.backgroundWhite)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Menu {
                                ForEach(categoryViewModel.sortedCategories) { category in
                                    Button(category.name) {
                                        selectedCategory = category.name
                                        showingCustomCategory = false
                                    }
                                }
                                
                                Button("Custom Category") {
                                    showingCustomCategory = true
                                    customCategoryName = ""
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.isEmpty ? "Select Category" : selectedCategory)
                                        .font(.ubuntu(16))
                                        .foregroundColor(selectedCategory.isEmpty ? AppColors.darkGray.opacity(0.6) : AppColors.darkGray)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.primaryBlue)
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(AppColors.backgroundWhite)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            if showingCustomCategory {
                                TextField("Enter category name", text: $customCategoryName)
                                    .font(.ubuntu(16))
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 12)
                                    .background(AppColors.backgroundWhite)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppColors.primaryYellow, lineWidth: 2)
                                    )
                                    .onChange(of: customCategoryName) { newValue in
                                        selectedCategory = newValue
                                    }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cooking Time (minutes)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            TextField("e.g., 25", text: $cookingTimeText)
                                .font(.ubuntu(16))
                                .keyboardType(.numberPad)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(AppColors.backgroundWhite)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("One ingredient per line")
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.darkGray.opacity(0.6))
                            
                            TextEditor(text: $ingredients)
                                .font(.ubuntu(16))
                                .padding(10)
                                .frame(minHeight: 100)
                                .background(AppColors.backgroundWhite)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cooking Steps *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            TextEditor(text: $steps)
                                .font(.ubuntu(16))
                                .padding(10)
                                .frame(minHeight: 120)
                                .background(AppColors.backgroundWhite)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            TextField("e.g., don't add sugar - banana is sweet enough", text: $notes)
                                .font(.ubuntu(16))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(AppColors.backgroundWhite)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        if isEditing {
                            Button(action: {
                                if let recipe = recipeViewModel.selectedRecipe {
                                    recipeViewModel.deleteRecipe(recipe)
                                    recipeViewModel.selectedRecipe = nil
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                Text("Delete Recipe")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.accentOrange)
                                    .cornerRadius(25)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            loadRecipeData()
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private func loadRecipeData() {
        if let recipe = recipeViewModel.selectedRecipe {
            recipeName = recipe.name
            selectedCategory = recipe.category
            cookingTimeText = recipe.cookingTime != nil ? String(recipe.cookingTime!) : ""
            ingredients = recipe.ingredients.joined(separator: "\n")
            steps = recipe.steps.joined(separator: "\n")
            notes = recipe.notes
        }
    }
    
    private func saveRecipe() {
        let trimmedName = recipeName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedIngredients = ingredients.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            validationMessage = "Please enter a recipe name"
            showingValidationAlert = true
            return
        }
        
        if trimmedIngredients.isEmpty {
            validationMessage = "Please add at least one ingredient"
            showingValidationAlert = true
            return
        }
        
        let ingredientsList = trimmedIngredients.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let stepsList = steps.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let cookingTime = Int(cookingTimeText.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if let existingRecipe = recipeViewModel.selectedRecipe {
            var updatedRecipe = existingRecipe
            updatedRecipe.name = trimmedName
            updatedRecipe.category = selectedCategory
            updatedRecipe.cookingTime = cookingTime
            updatedRecipe.ingredients = ingredientsList
            updatedRecipe.steps = stepsList
            updatedRecipe.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            
            recipeViewModel.updateRecipe(updatedRecipe)
        } else {
            let newRecipe = Recipe(
                name: trimmedName,
                category: selectedCategory,
                cookingTime: cookingTime,
                ingredients: ingredientsList,
                steps: stepsList,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            recipeViewModel.addRecipe(newRecipe)
        }
        
        if showingCustomCategory && !customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            _ = categoryViewModel.addCategory(customCategoryName)
        }
        
        recipeViewModel.selectedRecipe = nil
        presentationMode.wrappedValue.dismiss()
    }
}


