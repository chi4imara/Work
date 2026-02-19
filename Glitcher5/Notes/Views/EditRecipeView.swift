import SwiftUI

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    let recipeId: UUID
    @ObservedObject var recipeViewModel: RecipeViewModel
    
    @State private var dishName = ""
    @State private var meatType = ""
    @State private var cookingTime = ""
    @State private var sauceMarinate = ""
    @State private var cookingStep = ""
    @State private var comment = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var recipe: Recipe? {
        recipeViewModel.recipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        Group {
            if let recipe = recipe {
                NavigationView {
                    ZStack {
                        ColorManager.primaryGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                HStack {
                                    Button("Cancel") {
                                        dismiss()
                                    }
                                    .font(.playfairDisplay(size: 16, weight: .medium))
                                    .foregroundColor(ColorManager.lightBlue)
                                    
                                    Spacer()
                                    
                                    Text("Edit Recipe")
                                        .font(.playfairDisplay(size: 24, weight: .bold))
                                        .foregroundColor(ColorManager.primaryText)
                                    
                                    Spacer()
                                    
                                    Text("Cancel")
                                        .font(.playfairDisplay(size: 16, weight: .medium))
                                        .foregroundColor(Color.clear)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                        
                        VStack(spacing: 16) {
                            CustomTextField(
                                title: "Dish Name",
                                text: $dishName,
                                placeholder: "e.g., Ribeye Steak, BBQ Wings"
                            )
                            
                            CustomTextField(
                                title: "Meat Type",
                                text: $meatType,
                                placeholder: "e.g., Beef, Chicken, Pork, Fish, Vegetables"
                            )
                            
                            CustomTextField(
                                title: "Cooking Time (min)",
                                text: $cookingTime,
                                placeholder: "e.g., 12, 25, 40"
                            )
                            .keyboardType(.numberPad)
                            
                            CustomTextField(
                                title: "Sauce / Marinade",
                                text: $sauceMarinate,
                                placeholder: "e.g., Classic BBQ, Honey Mustard"
                            )
                            
                            CustomTextEditor(
                                title: "Cooking Step Description",
                                text: $cookingStep,
                                placeholder: "e.g., Grill on high heat for 2 minutes each side"
                            )
                            
                            CustomTextEditor(
                                title: "Comment",
                                text: $comment,
                                placeholder: "e.g., Best cooked medium rare (optional)"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.accentGradient)
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                                Spacer(minLength: 100)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .dismissKeyboardOnTap()
                .onAppear {
                    loadRecipeData(recipe: recipe)
                }
                .alert("Validation Error", isPresented: $showAlert) {
                    Button("OK") { }
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
    private func loadRecipeData(recipe: Recipe) {
        dishName = recipe.dishName
        meatType = recipe.meatType
        cookingTime = recipe.cookingTime
        sauceMarinate = recipe.sauceMarinate
        cookingStep = recipe.cookingStep
        comment = recipe.comment
    }
    
    private func saveChanges() {
        guard let recipe = recipe else { return }
        
        if recipeViewModel.isValidRecipe(
            dishName: dishName,
            meatType: meatType,
            cookingTime: cookingTime,
            sauceMarinate: sauceMarinate,
            cookingStep: cookingStep
        ) {
            var updatedRecipe = recipe
            updatedRecipe.dishName = dishName.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedRecipe.meatType = meatType.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedRecipe.cookingTime = cookingTime.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedRecipe.sauceMarinate = sauceMarinate.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedRecipe.cookingStep = cookingStep.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedRecipe.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            
            recipeViewModel.updateRecipe(updatedRecipe)
            dismiss()
        } else {
            alertMessage = "Please fill in all required fields (all except comment)"
            showAlert = true
        }
    }
}

#Preview {
    let recipe = Recipe(
        dishName: "Ribeye Steak",
        meatType: "Beef",
        cookingTime: "12",
        sauceMarinate: "Classic BBQ",
        cookingStep: "Grill on high heat",
        comment: "Medium rare"
    )
    let vm = RecipeViewModel()
    vm.recipes = [recipe]
    return EditRecipeView(
        recipeId: recipe.id,
        recipeViewModel: vm
    )
}
