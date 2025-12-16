import SwiftUI
import PhotosUI

struct EditRecipeView: View {
    let recipe: Recipe
    @EnvironmentObject var recipeManager: RecipeManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var description: String
    @State private var cookingTime: String
    @State private var selectedCategory: RecipeCategory
    @State private var selectedDifficulty: Recipe.Difficulty
    @State private var ingredients: [Ingredient]
    @State private var instructions: [String]
    @State private var newIngredientName = ""
    @State private var newIngredientAmount = ""
    @State private var newInstruction = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var selectedDate: Date
    @State private var hasCustomDate: Bool
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var hasNewImage = false
    
    init(recipe: Recipe) {
        self.recipe = recipe
        _name = State(initialValue: recipe.name)
        _description = State(initialValue: recipe.description)
        _cookingTime = State(initialValue: String(recipe.cookingTime))
        _selectedCategory = State(initialValue: recipe.category)
        _selectedDifficulty = State(initialValue: recipe.difficulty)
        _ingredients = State(initialValue: recipe.ingredients)
        _instructions = State(initialValue: recipe.instructions)
        _selectedDate = State(initialValue: recipe.date ?? Date())
        _hasCustomDate = State(initialValue: recipe.date != nil)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recipe Photo")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            PhotosPicker(
                                selection: $selectedPhoto,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                ZStack {
                                    if let image = selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(12)
                                    } else if let fileName = recipe.imageFileName,
                                              let existingImage = ImageManager.shared.loadImage(fileName: fileName) {
                                        Image(uiImage: existingImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(12)
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                            .frame(height: 200)
                                            .overlay(
                                                VStack(spacing: 12) {
                                                    Image(systemName: "photo.badge.plus")
                                                        .font(.system(size: 40))
                                                        .foregroundColor(AppColors.primaryBlue)
                                                    Text("Tap to change photo")
                                                        .font(.ubuntu(14, weight: .medium))
                                                        .foregroundColor(AppColors.textSecondary)
                                                }
                                            )
                                    }
                                }
                            }
                            .onChange(of: selectedPhoto) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data) {
                                        selectedImage = image.resized(to: CGSize(width: 1200, height: 1200))
                                        hasNewImage = true
                                    }
                                }
                            }
                            .onAppear {
                                if let fileName = recipe.imageFileName,
                                   let image = ImageManager.shared.loadImage(fileName: fileName) {
                                    selectedImage = image
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recipe Name")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter recipe name", text: $name)
                                .font(.ubuntu(16))
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Description")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter recipe description", text: $description, axis: .vertical)
                                .font(.ubuntu(16))
                                .lineLimit(3...6)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Category")
                                    .font(.ubuntu(16, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(RecipeCategory.allCases, id: \.self) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Difficulty")
                                    .font(.ubuntu(16, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Picker("Difficulty", selection: $selectedDifficulty) {
                                    ForEach(Recipe.Difficulty.allCases, id: \.self) { difficulty in
                                        Text(difficulty.rawValue).tag(difficulty)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cooking Time (minutes)")
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter cooking time", text: $cookingTime)
                                .keyboardType(.numberPad)
                                .font(.ubuntu(16))
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Recipe Date")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Toggle("", isOn: $hasCustomDate)
                                    .tint(AppColors.primaryYellow)
                            }
                            
                            if hasCustomDate {
                                DatePicker(
                                    "Select date",
                                    selection: $selectedDate,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .accentColor(AppColors.primaryYellow)
                            } else {
                                Text("Recipe will be added without a specific date")
                                    .font(.ubuntu(14, weight: .regular))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .cardStyle()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Ingredients")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Button(action: addIngredient) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppColors.primaryYellow)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                TextField("Ingredient name", text: $newIngredientName)
                                    .font(.ubuntu(14))
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                                
                                TextField("Amount", text: $newIngredientAmount)
                                    .font(.ubuntu(14))
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                            
                            ForEach(ingredients) { ingredient in
                                HStack {
                                    Text("\(ingredient.name) - \(ingredient.amount)")
                                        .font(.ubuntu(14))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        ingredients.removeAll { $0.id == ingredient.id }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(AppColors.accentRed)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .cardStyle()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Instructions")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Button(action: addInstruction) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppColors.primaryYellow)
                                }
                            }
                            
                            TextField("Enter instruction step", text: $newInstruction, axis: .vertical)
                                .font(.ubuntu(14))
                                .lineLimit(2...4)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(8)
                            
                            ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(index + 1)")
                                        .font(.ubuntu(14, weight: .bold))
                                        .foregroundColor(AppColors.textLight)
                                        .frame(width: 24, height: 24)
                                        .background(AppColors.primaryYellow)
                                        .clipShape(Circle())
                                    
                                    Text(instruction)
                                        .font(.ubuntu(14))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        instructions.remove(at: index)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(AppColors.accentRed)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .cardStyle()
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveRecipe()
                    }) {
                        Text("Save")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(isFormValid ? AppColors.primaryYellow : AppColors.textSecondary.opacity(0.5))
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTime = cookingTime.trimmingCharacters(in: .whitespacesAndNewlines)
        let timeValue = Int(trimmedTime)
        
        return !trimmedName.isEmpty &&
        !trimmedDescription.isEmpty &&
        !trimmedTime.isEmpty &&
        timeValue != nil &&
        timeValue! > 0 &&
        !ingredients.isEmpty &&
        !instructions.isEmpty
    }
    
    private func addIngredient() {
        guard !newIngredientName.isEmpty && !newIngredientAmount.isEmpty else { return }
        ingredients.append(Ingredient(name: newIngredientName, amount: newIngredientAmount))
        newIngredientName = ""
        newIngredientAmount = ""
    }
    
    private func addInstruction() {
        guard !newInstruction.isEmpty else { return }
        instructions.append(newInstruction)
        newInstruction = ""
    }
    
    private func saveRecipe() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTime = cookingTime.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            showError = true
            return
        }
        
        guard let time = Int(trimmedTime), time > 0 else {
            errorMessage = "Please enter a valid cooking time"
            showError = true
            return
        }
        
        let recipeDate = hasCustomDate ? Calendar.current.startOfDay(for: selectedDate) : nil
        
        var imageFileName = recipe.imageFileName
        
        if hasNewImage, let image = selectedImage {
            if let oldFileName = recipe.imageFileName {
                ImageManager.shared.deleteImage(fileName: oldFileName)
            }
            
            imageFileName = ImageManager.shared.saveImage(image, for: recipe.id)
            
            if imageFileName == nil {
                errorMessage = "Failed to save image. Please try again."
                showError = true
                return
            }
        }
        
        let updatedRecipe = Recipe(
            id: recipe.id,
            name: trimmedName,
            description: trimmedDescription,
            imageName: recipe.imageName,
            imageFileName: imageFileName,
            ingredients: ingredients,
            instructions: instructions,
            category: selectedCategory,
            cookingTime: time,
            difficulty: selectedDifficulty,
            date: recipeDate
        )
        
        recipeManager.updateRecipe(updatedRecipe)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
        }
    }
}

#Preview {
    EditRecipeView(recipe: Recipe(
        name: "Test Recipe",
        description: "Test description",
        ingredients: [Ingredient(name: "Test", amount: "1 cup")],
        instructions: ["Step 1"],
        category: .breakfast,
        cookingTime: 30,
        difficulty: .easy,
        date: nil
    ))
    .environmentObject(RecipeManager())
}

