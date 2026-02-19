import SwiftUI

struct EditRecipeView: View {
    let recipeId: UUID
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedCategory: RecipeCategory = .scrubs
    @State private var ingredients: String = ""
    @State private var proportions: String = ""
    @State private var process: String = ""
    @State private var notes: String = ""
    
    private var recipe: Recipe? {
        viewModel.recipes.first { $0.id == recipeId }
    }
    
    init(recipeId: UUID, viewModel: RecipeViewModel) {
        self.recipeId = recipeId
        self.viewModel = viewModel
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Group {
            if let currentRecipe = recipe {
                editRecipeContent(recipe: currentRecipe)
            } else {
                Text("Recipe not found")
                    .foregroundColor(ColorManager.primaryText)
            }
        }
        .onAppear {
            if let currentRecipe = recipe {
                name = currentRecipe.name
                selectedCategory = currentRecipe.category
                ingredients = currentRecipe.ingredients
                proportions = currentRecipe.proportions
                process = currentRecipe.process
                notes = currentRecipe.notes
            }
        }
    }
    
    private func editRecipeContent(recipe: Recipe) -> some View {
        let currentRecipe = recipe
        
        return NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.ubuntu(16))
                            .foregroundColor(ColorManager.accent)
                            
                            Spacer()
                            
                            Text("Edit Recipe")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            Button("Save") {
                                saveChanges()
                            }
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(isFormValid ? ColorManager.primaryText : ColorManager.secondaryText)
                            .disabled(!isFormValid)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        VStack(spacing: 16) {
                            FormFieldView(title: "Recipe Name", isRequired: true) {
                                TextField("Enter recipe name", text: $name)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                            
                            FormFieldView(title: "Category") {
                                Menu {
                                    ForEach(RecipeCategory.allCases) { category in
                                        Button(category.displayName) {
                                            selectedCategory = category
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.displayName)
                                            .font(.ubuntu(16))
                                            .foregroundColor(ColorManager.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(ColorManager.secondaryText)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                                }
                            }
                            
                            FormFieldView(title: "Ingredients") {
                                TextEditor(text: $ingredients)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 80)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                            
                            FormFieldView(title: "Proportions / Formula") {
                                TextEditor(text: $proportions)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                            
                            FormFieldView(title: "Preparation Process") {
                                TextEditor(text: $process)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                            
                            FormFieldView(title: "Notes (Optional)") {
                                TextEditor(text: $notes)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveChanges() {
        guard var updatedRecipe = recipe else { return }
        updatedRecipe.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedRecipe.category = selectedCategory
        updatedRecipe.ingredients = ingredients
        updatedRecipe.proportions = proportions
        updatedRecipe.process = process
        updatedRecipe.notes = notes
        
        viewModel.updateRecipe(updatedRecipe)
        presentationMode.wrappedValue.dismiss()
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
    
    return EditRecipeView(recipeId: sampleRecipe.id, viewModel: viewModel)
}
