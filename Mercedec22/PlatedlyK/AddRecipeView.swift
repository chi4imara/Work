import SwiftUI

struct AddRecipeView: View {
    let onSave: (Recipe) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var recipeName = ""
    @State private var selectedCategory: Recipe.MealCategory = .breakfast
    @State private var selectedDifficulty: Recipe.Difficulty = .beginner
    @State private var cookingTime = 15
    @State private var calories = 300
    @State private var ingredients: [TempIngredient] = [TempIngredient()]
    @State private var instructions: [String] = [""]
    @State private var notes = ""
    @State private var tags = ""
    
    @State private var protein: Double = 20
    @State private var carbs: Double = 30
    @State private var fat: Double = 10
    @State private var fiber: Double = 5
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        basicInfoSection
                        
                        detailsSection
                        
                        ingredientsSection
                        
                        instructionsSection
                        
                        nutritionSection
                        
                        notesSection
                        
                        saveButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("Add Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(AppColors.textPrimary)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveRecipe()
                }
                .foregroundColor(AppColors.primaryYellow)
                .disabled(recipeName.isEmpty)
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recipe Name *")
                        .font(AppFonts.body(14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    TextField("Enter recipe name", text: $recipeName)
                        .font(AppFonts.body(16))
                        .foregroundColor(AppColors.textPrimary)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.cardBackground.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                                )
                        )
                }
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(AppFonts.body(14))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Menu {
                            ForEach(Recipe.MealCategory.allCases, id: \.self) { category in
                                Button(category.rawValue) {
                                    selectedCategory = category
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedCategory.rawValue)
                                    .font(AppFonts.body(16))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.cardBackground.opacity(0.7))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Difficulty")
                            .font(AppFonts.body(14))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Menu {
                            ForEach(Recipe.Difficulty.allCases, id: \.self) { difficulty in
                                Button(difficulty.rawValue) {
                                    selectedDifficulty = difficulty
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedDifficulty.rawValue)
                                    .font(AppFonts.body(16))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.cardBackground.opacity(0.7))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recipe Details")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cooking Time (min)")
                        .font(AppFonts.body(14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack {
                        TextField("15", value: $cookingTime, format: .number)
                            .font(AppFonts.body(16))
                            .foregroundColor(AppColors.textPrimary)
                            .keyboardType(.numberPad)
                        
                        Text("min")
                            .font(AppFonts.caption(14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.cardBackground.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                            )
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Calories")
                        .font(AppFonts.body(14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack {
                        TextField("300", value: $calories, format: .number)
                            .font(AppFonts.body(16))
                            .foregroundColor(AppColors.textPrimary)
                            .keyboardType(.numberPad)
                        
                        Text("kcal")
                            .font(AppFonts.caption(14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.cardBackground.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                            )
                    )
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tags (comma separated)")
                    .font(AppFonts.body(14))
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("e.g. High Protein, Quick, Vegetarian", text: $tags)
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.cardBackground.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ingredients")
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("Add") {
                    ingredients.append(TempIngredient())
                }
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(spacing: 12) {
                ForEach(Array(ingredients.enumerated()), id: \.offset) { index, ingredient in
                    HStack(spacing: 12) {
                        TextField("Ingredient", text: $ingredients[index].name)
                            .font(AppFonts.body(14))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppColors.cardBackground.opacity(0.5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(AppColors.cardBorder.opacity(0.5), lineWidth: 1)
                                    )
                            )
                        
                        TextField("Amount", text: $ingredients[index].amount)
                            .font(AppFonts.body(14))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(8)
                            .frame(width: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppColors.cardBackground.opacity(0.5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(AppColors.cardBorder.opacity(0.5), lineWidth: 1)
                                    )
                            )
                        
                        TextField("Unit", text: $ingredients[index].unit)
                            .font(AppFonts.body(14))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(8)
                            .frame(width: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppColors.cardBackground.opacity(0.5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(AppColors.cardBorder.opacity(0.5), lineWidth: 1)
                                    )
                            )
                        
                        if ingredients.count > 1 {
                            Button(action: {
                                ingredients.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.secondaryPink)
                            }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Instructions")
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("Add Step") {
                    instructions.append("")
                }
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(spacing: 12) {
                ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primaryYellow)
                                .frame(width: 24, height: 24)
                            
                            Text("\(index + 1)")
                                .font(AppFonts.caption(12))
                                .foregroundColor(.black)
                        }
                        
                        TextField("Enter instruction step...", text: $instructions[index], axis: .vertical)
                            .font(AppFonts.body(14))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppColors.cardBackground.opacity(0.5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(AppColors.cardBorder.opacity(0.5), lineWidth: 1)
                                    )
                            )
                            .lineLimit(3...6)
                        
                        if instructions.count > 1 {
                            Button(action: {
                                instructions.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.secondaryPink)
                            }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Nutrition Information (per serving)")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    macroField(title: "Protein", value: $protein, unit: "g", color: AppColors.secondaryGreen)
                    macroField(title: "Carbs", value: $carbs, unit: "g", color: AppColors.secondaryOrange)
                }
                
                HStack(spacing: 16) {
                    macroField(title: "Fat", value: $fat, unit: "g", color: AppColors.secondaryPink)
                    macroField(title: "Fiber", value: $fiber, unit: "g", color: AppColors.secondaryPurple)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Additional Notes")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            TextField("Add any additional notes, tips, or variations...", text: $notes, axis: .vertical)
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.textPrimary)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.cardBackground.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                        )
                )
                .lineLimit(4...8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func macroField(title: String, value: Binding<Double>, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                
                Text(title)
                    .font(AppFonts.body(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            HStack {
                TextField("0", value: value, format: .number)
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textPrimary)
                    .keyboardType(.decimalPad)
                
                Text(unit)
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.cardBackground.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                    )
            )
        }
    }
    
    private var saveButton: some View {
        Button(action: { saveRecipe() }) {
            Text("Save Recipe")
                .font(AppFonts.button(18))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .fill(AppColors.primaryYellow)
                )
        }
        .disabled(recipeName.isEmpty)
        .opacity(recipeName.isEmpty ? 0.6 : 1)
    }
    
    private func saveRecipe() {
        let tagList = tags.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        let ingredientList = ingredients
            .filter { !$0.name.isEmpty }
            .map { Ingredient(name: $0.name, amount: $0.amount, unit: $0.unit) }
        let instructionList = instructions.filter { !$0.isEmpty }
        
        let recipe = Recipe(
            name: recipeName,
            cookingTime: cookingTime,
            difficulty: selectedDifficulty,
            calories: calories,
            category: selectedCategory,
            ingredients: ingredientList,
            instructions: instructionList,
            macros: Macros(protein: protein, carbs: carbs, fat: fat, fiber: fiber),
            tags: tagList
        )
        onSave(recipe)
        dismiss()
    }
}

struct TempIngredient {
    var name: String = ""
    var amount: String = ""
    var unit: String = ""
}

#Preview {
    AddRecipeView(onSave: { _ in })
}
