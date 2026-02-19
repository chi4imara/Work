import SwiftUI

struct NewRecipeView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var appViewModel: AppViewModel
    
    @State private var dishName = ""
    @State private var meatType = ""
    @State private var cookingTime = ""
    @State private var sauceMarinate = ""
    @State private var cookingStep = ""
    @State private var comment = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("New Recipe")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.vertical, 10)
                    
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
                    
                    Button(action: saveRecipe) {
                        Text("Save Recipe")
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
                }
                .padding(.bottom, 120)
            }
        }
        .dismissKeyboardOnTap()
        .alert("Validation Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveRecipe() {
        if recipeViewModel.isValidRecipe(
            dishName: dishName,
            meatType: meatType,
            cookingTime: cookingTime,
            sauceMarinate: sauceMarinate,
            cookingStep: cookingStep
        ) {
            let newRecipe = Recipe(
                dishName: dishName.trimmingCharacters(in: .whitespacesAndNewlines),
                meatType: meatType.trimmingCharacters(in: .whitespacesAndNewlines),
                cookingTime: cookingTime.trimmingCharacters(in: .whitespacesAndNewlines),
                sauceMarinate: sauceMarinate.trimmingCharacters(in: .whitespacesAndNewlines),
                cookingStep: cookingStep.trimmingCharacters(in: .whitespacesAndNewlines),
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            recipeViewModel.addRecipe(newRecipe)
            appViewModel.showRecipeSavedScreen(recipe: newRecipe)
            clearFields()
        } else {
            alertMessage = "Please fill in all required fields (all except comment)"
            showAlert = true
        }
    }
    
    private func clearFields() {
        dishName = ""
        meatType = ""
        cookingTime = ""
        sauceMarinate = ""
        cookingStep = ""
        comment = ""
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(ColorManager.secondaryBackground.opacity(0.8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                        }
                )
        }
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(ColorManager.secondaryBackground.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                    }
                    .frame(minHeight: 80)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.playfairDisplay(size: 16))
                        .foregroundColor(ColorManager.placeholderText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(ColorManager.primaryText)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .frame(minHeight: 80)
            }
        }
    }
}

#Preview {
    NewRecipeView(recipeViewModel: RecipeViewModel(), appViewModel: AppViewModel())
}
