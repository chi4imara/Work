import SwiftUI

struct AddEditRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var recipeStore: RecipeStore
    
    let recipe: Recipe?
    let category: String?
    let onSave: (Recipe) -> Void
    
    @State private var title: String = ""
    @State private var ingredients: String = ""
    @State private var instructions: String = ""
    @State private var selectedCategory: String? = nil
    @State private var showingCancelAlert = false
    @State private var showingValidationError = false
    
    init(recipe: Recipe? = nil, category: String? = nil, onSave: @escaping (Recipe) -> Void) {
        self.recipe = recipe
        self.category = category
        self.onSave = onSave
    }
    
    private var isEditing: Bool {
        recipe != nil
    }
    
    private var hasChanges: Bool {
        if let recipe = recipe {
            return title != recipe.title ||
                   ingredients != recipe.ingredients ||
                   instructions != recipe.instructions ||
                   selectedCategory != recipe.category
        } else {
            return !title.isEmpty || !ingredients.isEmpty || !instructions.isEmpty || selectedCategory != nil
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recipe Title")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("For example: \"Oatmeal with apples\", \"Homemade potatoes\"", text: $title)
                                .font(FontManager.body)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(16)
                                .background(AppColors.cardGradient)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ingredients")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            ZStack(alignment: .topLeading) {
                                if ingredients.isEmpty {
                                    Text("List main ingredients separated by commas:\npotatoes, oil, salt, herbs.")
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.textSecondary.opacity(0.7))
                                        .padding(16)
                                }
                                
                                TextEditor(text: $ingredients)
                                    .font(FontManager.body)
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(12)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                            }
                            .frame(minHeight: 100)
                            .background(AppColors.cardGradient)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cooking Instructions")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            ZStack(alignment: .topLeading) {
                                if instructions.isEmpty {
                                    Text("Describe in 2-3 sentences how to cook.\nFor example: \"Fry onions, add potatoes, simmer for 20 minutes.\"")
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.textSecondary.opacity(0.7))
                                        .padding(16)
                                }
                                
                                TextEditor(text: $instructions)
                                    .font(FontManager.body)
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(12)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                            }
                            .frame(minHeight: 120)
                            .background(AppColors.cardGradient)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    CategoryChip(
                                        name: "None",
                                        isSelected: selectedCategory == nil,
                                        color: AppColors.textSecondary
                                    ) {
                                        selectedCategory = nil
                                    }
                                    
                                    ForEach(RecipeCategory.allCategories, id: \.rawValue) { category in
                                        CategoryChip(
                                            name: category.displayName,
                                            isSelected: selectedCategory == category.rawValue,
                                            color: category.color
                                        ) {
                                            selectedCategory = category.rawValue
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: saveRecipe) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                    Text("Save Recipe")
                                        .font(FontManager.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.primaryBlue)
                                .cornerRadius(25)
                            }
                            
                            Button(action: cancelAction) {
                                Text("Cancel")
                                    .font(FontManager.callout)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(isEditing ? "Edit Recipe" : "New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        cancelAction()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .onAppear {
            if let recipe = recipe {
                title = recipe.title
                ingredients = recipe.ingredients
                instructions = recipe.instructions
                selectedCategory = recipe.category
            } else if let category = category {
                selectedCategory = category
            }
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") { }
        } message: {
            Text("Add at least a dish name to save the recipe.")
        }
        .alert("Exit without saving?", isPresented: $showingCancelAlert) {
            Button("No", role: .cancel) { }
            Button("Yes", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("You have unsaved changes. Are you sure you want to exit?")
        }
    }
    
    private func saveRecipe() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingValidationError = true
            return
        }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedIngredients = ingredients.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedInstructions = instructions.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if var existingRecipe = recipe {
            existingRecipe.updateContent(
                title: trimmedTitle,
                ingredients: trimmedIngredients,
                instructions: trimmedInstructions,
                category: selectedCategory
            )
            onSave(existingRecipe)
        } else {
            let newRecipe = Recipe(
                title: trimmedTitle,
                ingredients: trimmedIngredients,
                instructions: trimmedInstructions,
                category: selectedCategory
            )
            onSave(newRecipe)
        }
        
        dismiss()
    }
    
    private func cancelAction() {
        if hasChanges {
            showingCancelAlert = true
        } else {
            dismiss()
        }
    }
}

struct CategoryChip: View {
    let name: String
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(name)
                .font(FontManager.callout)
                .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? AnyShapeStyle(color) : AnyShapeStyle(AppColors.cardGradient))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
