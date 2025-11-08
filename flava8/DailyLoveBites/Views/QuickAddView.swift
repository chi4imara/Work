import SwiftUI

struct QuickAddView: View {
    @ObservedObject private var viewModel = RecipeViewModel.shared
    @State private var showingAddRecipe = false
    @State private var quickRecipeName = ""
    @State private var quickRecipeTime = ""
    @State private var quickRecipeDifficulty: Recipe.Difficulty = .easy
    @State private var quickRecipeTag = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    quickAddForm
                    
                    recentRecipesSection
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddRecipe) {
                AddEditRecipeView(viewModel: viewModel)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quick Add")
                        .font(AppFonts.titleLarge)
                        .foregroundColor(.white)
                    
                    Text("Add recipes in seconds")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Button(action: { showingAddRecipe = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryPurple)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var quickAddForm: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Quick Recipe")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recipe Name")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.white)
                    
                    TextField("Enter recipe name", text: $quickRecipeName)
                        .font(AppFonts.bodyMedium)
                        .padding(12)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8)
                }
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time (min)")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.white)
                        
                        TextField("30", text: $quickRecipeTime)
                            .font(AppFonts.bodyMedium)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Difficulty")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.white)
                        
                        Picker("Difficulty", selection: $quickRecipeDifficulty) {
                            ForEach(Recipe.Difficulty.allCases, id: \.self) { difficulty in
                                Text(difficulty.localizedString).tag(difficulty)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(12)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick Tag")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.white)
                    
                    TextField("e.g., quick, dinner", text: $quickRecipeTag)
                        .font(AppFonts.bodyMedium)
                        .onChange(of: quickRecipeTag) { newValue in
                            if newValue.count > 24 {
                                quickRecipeTag = String(newValue.prefix(24))
                            }
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8)
                }
                
                Button(action: addQuickRecipe) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Recipe")
                    }
                    .font(AppFonts.buttonMedium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient.buttonGradient
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.primaryPurple.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .disabled(quickRecipeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(20)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var recentRecipesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Recipes")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            if viewModel.recipes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("No recipes yet")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(viewModel.recipes.sorted { $0.createdAt > $1.createdAt }.prefix(5)), id: \.id) { recipe in
                            RecentRecipeCard(recipe: recipe)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func addQuickRecipe() {
        let tags = quickRecipeTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? [] : [quickRecipeTag.trimmingCharacters(in: .whitespacesAndNewlines)]
        
        let newRecipe = Recipe(
            name: quickRecipeName.trimmingCharacters(in: .whitespacesAndNewlines),
            servings: 2,
            cookingTime: Int(quickRecipeTime) ?? nil,
            difficulty: quickRecipeDifficulty,
            tags: tags,
            ingredients: [Ingredient(quantity: "1", name: "ingredient")],
            steps: [CookingStep(description: "Add cooking instructions")],
            isFavorite: false,
            notes: "Quick added recipe - edit to add details"
        )
        
        viewModel.addRecipe(newRecipe)
        
        quickRecipeName = ""
        quickRecipeTime = ""
        quickRecipeTag = ""
        quickRecipeDifficulty = .easy
    }
}

struct RecentRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.primaryPurple, Color.accentOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: "book.closed")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text(recipe.name)
                .font(AppFonts.bodySmall)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            Text(recipe.metadataString)
                .font(AppFonts.caption)
                .foregroundColor(.secondaryText)
                .lineLimit(1)
        }
        .frame(width: 100)
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    QuickAddView()
}
