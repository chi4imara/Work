import SwiftUI

struct TodayView: View {
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var showMenu = false
    @State private var showAddRecipe = false
    
    private var checkedIngredients: Binding<Set<UUID>> {
        Binding(
            get: {
                if let recipeId = recipeManager.todayRecipe?.id {
                    return recipeManager.getCheckedIngredients(for: recipeId)
                }
                return []
            },
            set: { _ in }
        )
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Recipe of the Day")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            showAddRecipe = true
                        }) {
                            Label("Add Recipe", systemImage: "plus")
                        }
                        
                        if recipeManager.todayRecipe != nil {
                            Divider()
                            
                            Button(action: {
                                if let recipe = recipeManager.todayRecipe {
                                    recipeManager.toggleFavorite(recipe)
                                }
                            }) {
                                Label(
                                    recipeManager.todayRecipe.map(recipeManager.isFavorite) == true ? "Remove from Favorites" : "Add to Favorites",
                                    systemImage: recipeManager.todayRecipe.map(recipeManager.isFavorite) == true ? "star.slash" : "star"
                                )
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
               if let recipe = recipeManager.todayRecipe {
                    RecipeContentView(
                        recipe: recipe,
                        checkedIngredients: checkedIngredients.wrappedValue,
                        recipeId: recipe.id,
                        isFavorite: recipeManager.isFavorite(recipe),
                        onFavoriteToggle: {
                            recipeManager.toggleFavorite(recipe)
                        }
                    )
                    .environmentObject(recipeManager)
                } else {
                    EmptyStateView(
                        icon: "fork.knife",
                        title: "Today's Recipe",
                        message: "Today's recipe will appear soon"
                    )
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showAddRecipe) {
            AddRecipeView()
                .environmentObject(recipeManager)
        }
    }
}

struct RecipeContentView: View {
    let recipe: Recipe
    let checkedIngredients: Set<UUID>
    let recipeId: UUID
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    @EnvironmentObject var recipeManager: RecipeManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                RecipeImageView(recipe: recipe)
                
                VStack(alignment: .leading, spacing: 20) {
                    RecipeInfoView(recipe: recipe)
                    
                    IngredientsSection(
                        ingredients: recipe.ingredients,
                        checkedIngredients: checkedIngredients,
                        recipeId: recipeId
                    )
                    .environmentObject(recipeManager)
                    
                    InstructionsSection(instructions: recipe.instructions)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RecipeImageView: View {
    let recipe: Recipe
    @State private var loadedImage: UIImage?
    
    var body: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } else {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                recipe.category.color.opacity(0.3),
                                recipe.category.color.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.textSecondary.opacity(0.5))
                    )
            }
        }
        .cornerRadius(15)
        .padding(.horizontal)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let fileName = recipe.imageFileName, !fileName.isEmpty else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = ImageManager.shared.loadImage(fileName: fileName) {
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            }
        }
    }
}

struct RecipeInfoView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.name)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(recipe.description)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(2)
            
            HStack(spacing: 20) {
                InfoChip(icon: "clock", text: "\(recipe.cookingTime) min")
                InfoChip(icon: "chart.bar", text: recipe.difficulty.rawValue)
                InfoChip(icon: recipe.category.icon, text: recipe.category.rawValue)
            }
        }
        .padding()
        .cardStyle()
    }
}

struct InfoChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(.ubuntu(12, weight: .medium))
        }
        .foregroundColor(AppColors.textSecondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(AppColors.primaryBlue.opacity(0.1))
        .cornerRadius(8)
    }
}

struct IngredientsSection: View {
    let ingredients: [Ingredient]
    let checkedIngredients: Set<UUID>
    let recipeId: UUID?
    @EnvironmentObject var recipeManager: RecipeManager
    
    private var currentCheckedIngredients: Set<UUID> {
        if let recipeId = recipeId {
            return recipeManager.getCheckedIngredients(for: recipeId)
        }
        return checkedIngredients
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ingredients")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(ingredients) { ingredient in
                    IngredientRow(
                        ingredient: ingredient,
                        isChecked: currentCheckedIngredients.contains(ingredient.id)
                    ) {
                        if let recipeId = recipeId {
                            recipeManager.toggleIngredient(ingredient.id, for: recipeId)
                        }
                    }
                }
            }
        }
        .padding()
        .cardStyle()
    }
}

struct IngredientRow: View {
    let ingredient: Ingredient
    let isChecked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? AppColors.accentGreen : AppColors.textSecondary)
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(ingredient.name)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .strikethrough(isChecked)
                    
                    Text(ingredient.amount)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InstructionsSection: View {
    let instructions: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Instructions")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                    InstructionRow(number: index + 1, instruction: instruction)
                }
            }
        }
        .padding()
        .cardStyle()
    }
}

struct InstructionRow: View {
    let number: Int
    let instruction: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.textLight)
                .frame(width: 28, height: 28)
                .background(AppColors.primaryYellow)
                .clipShape(Circle())
            
            Text(instruction)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textPrimary)
                .lineSpacing(2)
            
            Spacer()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(AppColors.primaryYellow)
            
            Text("Loading today's recipe...")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(message)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TodayView()
        .environmentObject(RecipeManager())
}
