import SwiftUI

struct AddRecipeView: View {
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var cookingTime = 10
    @State private var ingredients: [String] = [""]
    @State private var instructions: [String] = [""]
    @State private var selectedCategory: Recipe.RecipeCategory = .quick
    
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
            .navigationTitle("Add Recipe")
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
            .preferredColorScheme(.dark)
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
        
        let newRecipe = Recipe(
            name: name,
            cookingTime: cookingTime,
            ingredients: filteredIngredients,
            instructions: filteredInstructions,
            category: selectedCategory
        )
        
        appState.addRecipe(newRecipe)
        dismiss()
    }
}

#Preview {
    AddRecipeView(appState: AppState())
}
