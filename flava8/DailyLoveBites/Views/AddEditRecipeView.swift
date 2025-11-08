import SwiftUI

struct AddEditRecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let editingRecipe: Recipe?
    
    @State private var name: String = ""
    @State private var servings: String = "2"
    @State private var cookingTime: String = ""
    @State private var difficulty: Recipe.Difficulty = .easy
    @State private var tagInput: String = ""
    @State private var tags: [String] = []
    @State private var ingredients: [Ingredient] = [Ingredient()]
    @State private var steps: [CookingStep] = [CookingStep()]
    @State private var isFavorite: Bool = false
    @State private var notes: String = ""
    
    @State private var showingValidationErrors = false
    @State private var validationErrors: [String] = []
    
    init(viewModel: RecipeViewModel, editingRecipe: Recipe? = nil) {
        self.viewModel = viewModel
        self.editingRecipe = editingRecipe
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        basicFieldsSection
                        
                        tagsSection
                        
                        ingredientsSection
                        
                        stepsSection
                        
                        favoriteSection
                        
                        notesSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle(editingRecipe == nil ? "New Recipe" : "Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveRecipe()
                }
                .disabled(!isValidRecipe)
            )
            .preferredColorScheme(.dark)
            .onAppear {
                loadRecipeData()
            }
            .alert("Validation Errors", isPresented: $showingValidationErrors) {
                Button("OK") { }
            } message: {
                Text(validationErrors.joined(separator: "\n"))
            }
        }
    }
    
    private var basicFieldsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Name *")
                        .font(AppFonts.bodySmall)
                        .foregroundColor(.darkGray)
                    
                    TextField("Recipe name", text: $name)
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            Text("Recipe name")
                                .font(AppFonts.bodyMedium)
                                .foregroundColor(.gray)
                                .opacity(name.isEmpty ? 1 : 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                        )
                }
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Servings *")
                            .font(AppFonts.bodySmall)
                            .foregroundColor(.darkGray)
                        
                        TextField("", text: $servings)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.black)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                Text("2")
                                    .font(AppFonts.bodyMedium)
                                    .foregroundColor(.gray)
                                    .opacity(servings.isEmpty ? 1 : 0)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 12)
                            )
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Time (min)")
                            .font(AppFonts.bodySmall)
                            .foregroundColor(.darkGray)
                        
                        TextField("", text: $cookingTime)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.black)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                   Text("30")
                                       .font(AppFonts.bodyMedium)
                                       .foregroundColor(.gray)
                                       .opacity(cookingTime.isEmpty ? 1 : 0)
                                       .frame(maxWidth: .infinity, alignment: .leading)
                                       .padding(.horizontal, 12)
                               )
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Difficulty")
                        .font(AppFonts.bodySmall)
                        .foregroundColor(.darkGray)
                    
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Recipe.Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.localizedString).tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
        }
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tags")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        TextField("", text: $tagInput)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.black)
                            .overlay (
                                Text("Add tag...")
                                    .font(AppFonts.bodyMedium)
                                    .foregroundColor(.gray)
                                    .opacity(tagInput.isEmpty ? 1 : 0)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            )
                            .onChange(of: tagInput) { newValue in
                                if newValue.count > 24 {
                                    tagInput = String(newValue.prefix(24))
                                }
                            }
                            .onSubmit {
                                addTag()
                            }
                        
                        Button("Add", action: addTag)
                            .foregroundColor(.black)
                            .disabled(tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    
                    HStack {
                        Spacer()
                        Text("\(tagInput.count)/24")
                            .font(AppFonts.caption)
                            .foregroundColor(tagInput.count > 20 ? .errorRed : .darkGray)
                    }
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                
                if !tags.isEmpty {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            HStack(spacing: 4) {
                                Text("#\(tag)")
                                    .font(AppFonts.bodySmall)
                                
                                Button(action: { removeTag(tag) }) {
                                    Image(systemName: "xmark")
                                        .font(AppFonts.caption)
                                }
                            }
                            .foregroundColor(.primaryPurple)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.primaryPurple.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
        }
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ingredients *")
                    .font(AppFonts.titleSmall)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: addIngredient) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.primaryPurple)
                        .clipShape(Circle())
                }
            }
            
            VStack(spacing: 8) {
                ForEach(ingredients.indices, id: \.self) { index in
                    IngredientRow(
                        ingredient: $ingredients[index],
                        onDelete: {
                            if ingredients.count > 1 {
                                ingredients.remove(at: index)
                            }
                        },
                        onMove: { from, to in
                            ingredients.move(fromOffsets: IndexSet([from]), toOffset: to)
                        }
                    )
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
        }
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Cooking Steps *")
                    .font(AppFonts.titleSmall)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: addStep) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.primaryPurple)
                        .clipShape(Circle())
                }
            }
            
            VStack(spacing: 8) {
                ForEach(steps.indices, id: \.self) { index in
                    StepRow(
                        step: $steps[index],
                        stepNumber: index + 1,
                        onDelete: {
                            if steps.count > 1 {
                                steps.remove(at: index)
                            }
                        }
                    )
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
        }
    }
    
    private var favoriteSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Add to Favorites")
                    .font(AppFonts.titleSmall)
                    .foregroundColor(.black)
                
                Spacer()
                
                Toggle("", isOn: $isFavorite)
                    .toggleStyle(SwitchToggleStyle(tint: .primaryPurple))
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notes")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            TextField("", text: $notes, axis: .vertical)
                .font(AppFonts.bodyMedium)
                .foregroundColor(.black)
                .lineLimit(3...6)
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    Text("Additional notes...")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.gray)
                        .opacity(notes.isEmpty ? 1 : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 28)
                )
                .padding(16)
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
        }
    }
    
    private var isValidRecipe: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Int(servings) ?? 0 > 0 &&
        ingredients.contains { $0.isValid } &&
        steps.contains { $0.isValid }
    }
    
    private func loadRecipeData() {
        guard let recipe = editingRecipe else { return }
        
        name = recipe.name
        servings = String(recipe.servings)
        cookingTime = recipe.cookingTime.map(String.init) ?? ""
        difficulty = recipe.difficulty
        tags = recipe.tags
        ingredients = recipe.ingredients.isEmpty ? [Ingredient()] : recipe.ingredients
        steps = recipe.steps.isEmpty ? [CookingStep()] : recipe.steps
        isFavorite = recipe.isFavorite
        notes = recipe.notes ?? ""
    }
    
    private func addTag() {
        let trimmedTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTag.isEmpty,
              trimmedTag.count <= 24,
              !tags.contains(trimmedTag) else { return }
        
        tags.append(trimmedTag)
        tagInput = ""
    }
    
    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    private func addIngredient() {
        ingredients.append(Ingredient())
    }
    
    private func addStep() {
        steps.append(CookingStep())
    }
    
    private func saveRecipe() {
        guard validateRecipe() else {
            showingValidationErrors = true
            return
        }
        
        let cleanedIngredients = ingredients.filter { $0.isValid }
        let cleanedSteps = steps.filter { $0.isValid }
        
        if let originalRecipe = editingRecipe {
            var updatedRecipe = originalRecipe
            updatedRecipe.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedRecipe.servings = Int(servings) ?? 2
            updatedRecipe.cookingTime = cookingTime.isEmpty ? nil : Int(cookingTime)
            updatedRecipe.difficulty = difficulty
            updatedRecipe.tags = tags
            updatedRecipe.ingredients = cleanedIngredients
            updatedRecipe.steps = cleanedSteps
            updatedRecipe.isFavorite = isFavorite
            updatedRecipe.notes = notes.isEmpty ? nil : notes
            
            viewModel.updateRecipe(updatedRecipe)
        } else {
            let newRecipe = Recipe(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                servings: Int(servings) ?? 2,
                cookingTime: cookingTime.isEmpty ? nil : Int(cookingTime),
                difficulty: difficulty,
                tags: tags,
                ingredients: cleanedIngredients,
                steps: cleanedSteps,
                isFavorite: isFavorite,
                notes: notes.isEmpty ? nil : notes
            )
            viewModel.addRecipe(newRecipe)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func validateRecipe() -> Bool {
        validationErrors.removeAll()
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrors.append("Recipe name is required")
        }
        
        if Int(servings) ?? 0 <= 0 {
            validationErrors.append("Servings must be greater than 0")
        }
        
        if !ingredients.contains(where: { $0.isValid }) {
            validationErrors.append("At least one valid ingredient is required")
        }
        
        if !steps.contains(where: { $0.isValid }) {
            validationErrors.append("At least one cooking step is required")
        }
        
        return validationErrors.isEmpty
    }
}

struct IngredientRow: View {
    @Binding var ingredient: Ingredient
    let onDelete: () -> Void
    let onMove: (Int, Int) -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.secondaryGray)
            
            TextField("Quantity", text: $ingredient.quantity)
                .font(AppFonts.bodySmall)
                .foregroundColor(.black)
                .placeholder(when: ingredient.quantity.isEmpty) {
                    Text("Quantity")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.gray)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
            
            Divider()
            
            TextField("Ingredient name", text: $ingredient.name)
                .font(AppFonts.bodySmall)
                .foregroundColor(.black)
                .placeholder(when: ingredient.name.isEmpty) {
                    Text("Ingredient name")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.gray)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
    }
}

struct StepRow: View {
    @Binding var step: CookingStep
    let stepNumber: Int
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(stepNumber).")
                .font(AppFonts.bodyMedium)
                .foregroundColor(.primaryPurple)
                .frame(width: 20, alignment: .leading)
            
            TextField("", text: $step.description, axis: .vertical)
                .font(AppFonts.bodySmall)
                .foregroundColor(.black)
                .lineLimit(2...4)
                .overlay(
                    Text("Describe this step...")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.gray)
                        .opacity(step.description.isEmpty ? 1 : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
