import SwiftUI

struct AddEditRecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingRecipe: Recipe?
    
    @State private var title: String = ""
    @State private var selectedCategory: RecipeCategory = .other
    @State private var selectedCustomCategory: CustomCategory? = nil
    @State private var ingredients: [String] = [""]
    @State private var instructions: String = ""
    @State private var newIngredient: String = ""
    @State private var showingCategoryManager = false
    
    init(viewModel: RecipeViewModel, editingRecipe: Recipe? = nil) {
        self.viewModel = viewModel
        self.editingRecipe = editingRecipe
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recipe Name *")
                                .font(.ubuntuSubheadline)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter recipe name", text: $title)
                                .font(.ubuntuBody)
                                .foregroundColor(.textPrimary)
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        Divider()
                            .overlay {
                                Color.white
                            }
                            .padding(.horizontal, -20)
                            .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Category")
                                    .font(.ubuntuSubheadline)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Button(action: {
                                    showingCategoryManager = true
                                }) {
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primaryPurple)
                                }
                            }
                            
                            Menu {
                                ForEach(RecipeCategory.allCases.filter { $0 != .custom }, id: \.self) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                        selectedCustomCategory = nil
                                    }
                                }
                                
                                if !viewModel.getAllCustomCategories().isEmpty {
                                    Divider()
                                    
                                    ForEach(viewModel.getAllCustomCategories()) { customCategory in
                                        Button(customCategory.name) {
                                            selectedCategory = .custom
                                            selectedCustomCategory = customCategory
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCustomCategory?.name ?? selectedCategory.displayName)
                                        .font(.ubuntuBody)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                }
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                            }
                        }
                        
                        Divider()
                            .overlay {
                                Color.white
                            }
                            .padding(.horizontal, -20)
                            .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Ingredients")
                                    .font(.ubuntuSubheadline)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Button(action: addIngredient) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.primaryPurple)
                                }
                            }
                            
                            ForEach(ingredients.indices, id: \.self) { index in
                                HStack {
                                    TextField("Ingredient", text: $ingredients[index])
                                        .font(.ubuntuBody)
                                        .foregroundColor(.textPrimary)
                                        .padding(16)
                                        .background(Color.cardBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.cardBorder, lineWidth: 1)
                                        )
                                    
                                    if ingredients.count > 1 {
                                        Button(action: {
                                            removeIngredient(at: index)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.accentRed)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Divider()
                            .overlay {
                                Color.white
                            }
                            .padding(.horizontal, -20)
                            .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Instructions")
                                .font(.ubuntuSubheadline)
                                .foregroundColor(.textPrimary)
                            
                            TextEditor(text: $instructions)
                                .font(.ubuntuBody)
                                .foregroundColor(.textPrimary)
                                .padding(12)
                                .frame(minHeight: 120)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingRecipe == nil ? "New Recipe" : "Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .foregroundColor(canSave ? .primaryPurple : .textTertiary)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            setupForEditing()
        }
        .sheet(isPresented: $showingCategoryManager) {
            CategoryManagerView(viewModel: viewModel)
        }
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func setupForEditing() {
        if let recipe = editingRecipe {
            title = recipe.title
            selectedCategory = recipe.category
            
            if recipe.category == .custom {
                selectedCategory = .other
                selectedCustomCategory = nil
            } else {
                selectedCustomCategory = nil
            }
            
            ingredients = recipe.ingredients.isEmpty ? [""] : recipe.ingredients
            instructions = recipe.instructions
        }
    }
    
    private func addIngredient() {
        ingredients.append("")
    }
    
    private func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
    
    private func saveRecipe() {
        let cleanedIngredients = ingredients
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        if let existingRecipe = editingRecipe {
            var updatedRecipe = existingRecipe
            updatedRecipe.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedRecipe.category = selectedCategory
            updatedRecipe.ingredients = cleanedIngredients
            updatedRecipe.instructions = instructions
            
            viewModel.updateRecipe(updatedRecipe)
        } else {
            let newRecipe = Recipe(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                ingredients: cleanedIngredients,
                instructions: instructions
            )
            
            viewModel.addRecipe(newRecipe)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditRecipeView(viewModel: RecipeViewModel())
}
