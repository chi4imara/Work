import SwiftUI

enum CategoriesSheetItem: Identifiable {
    case categoryRecipes(String)
    
    var id: String {
        switch self {
        case .categoryRecipes(let categoryName):
            return "categoryRecipes-\(categoryName)"
        }
    }
}

struct CategoriesView: View {
    @EnvironmentObject var recipeStore: RecipeStore
    @State private var sheetItem: CategoriesSheetItem?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Categories")
                            .font(FontManager.title1)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(RecipeCategory.allCategories, id: \.rawValue) { category in
                                CategoryCard(
                                    category: category,
                                    recipeCount: recipeStore.getRecipesCount(for: category.rawValue),
                                    onTap: {
                                        sheetItem = .categoryRecipes(category.rawValue)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .categoryRecipes(let categoryName):
                CategoryRecipesView(categoryName: categoryName)
                    .environmentObject(recipeStore)
            }
        }
    }
}

struct CategoryCard: View {
    let category: RecipeCategory
    let recipeCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(category.color.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .fill(category.color)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 6) {
                    Text(category.displayName)
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("\(recipeCount) \(recipeCount == 1 ? "recipe" : "recipes")")
                        .font(FontManager.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(AppColors.cardGradient)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum CategoryRecipesSheetItem: Identifiable {
    case addRecipe(Recipe?, String)
    case recipeDetail(UUID)
    
    var id: String {
        switch self {
        case .addRecipe(let recipe, let category):
            return "addRecipe-\(recipe?.id.uuidString ?? "new")-\(category)"
        case .recipeDetail(let id):
            return "recipeDetail-\(id.uuidString)"
        }
    }
}

struct CategoryRecipesView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var recipeStore: RecipeStore
    @EnvironmentObject var noteStore: NoteStore
    
    let categoryName: String
    
    @State private var sheetItem: CategoryRecipesSheetItem?
    @State private var showingDeleteAlert = false
    @State private var recipeToDelete: Recipe?
    
    private var categoryRecipes: [Recipe] {
        recipeStore.getRecipes(for: categoryName)
    }
    
    private var category: RecipeCategory? {
        RecipeCategory.allCategories.first { $0.rawValue == categoryName }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            if let category = category {
                                ZStack {
                                    Circle()
                                        .fill(category.color.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: category.icon)
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(category.color)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(categoryName)
                                    .font(FontManager.title1)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("\(categoryRecipes.count) \(categoryRecipes.count == 1 ? "recipe" : "recipes")")
                                    .font(FontManager.caption1)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if categoryRecipes.isEmpty {
                        EmptyCategoryView(categoryName: categoryName) {
                            sheetItem = .addRecipe(nil, categoryName)
                        }
                    } else {
                        RecipesList(
                            recipes: categoryRecipes,
                            onRecipeTap: { recipe in
                                sheetItem = .recipeDetail(recipe.id)
                            },
                            onRecipeEdit: { recipe in
                                sheetItem = .addRecipe(recipe, categoryName)
                            },
                            onRecipeDelete: { recipe in
                                recipeToDelete = recipe
                                showingDeleteAlert = true
                            }
                        )
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                            Text("Back")
                        }
                        .foregroundColor(AppColors.primaryBlue)
                    }
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addRecipe(let recipe, let category):
                AddEditRecipeView(recipe: recipe, category: category) { updatedRecipe in
                    if recipe != nil {
                        recipeStore.updateRecipe(updatedRecipe)
                    } else {
                        recipeStore.addRecipe(updatedRecipe)
                    }
                }
                .environmentObject(recipeStore)
            case .recipeDetail(let recipeId):
                RecipeDetailView(recipeId: recipeId)
                    .environmentObject(recipeStore)
                    .environmentObject(noteStore)
            }
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                recipeToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let recipe = recipeToDelete {
                    recipeStore.deleteRecipe(recipe)
                }
                recipeToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this recipe? This action cannot be undone.")
        }
    }
}

struct EmptyCategoryView: View {
    let categoryName: String
    let onAddRecipe: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                
                VStack(spacing: 8) {
                    Image(systemName: "folder")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            
            VStack(spacing: 12) {
                Text("No recipes in \(categoryName)")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Add your first recipe to this category.")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: onAddRecipe) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    Text("Add Recipe")
                        .font(FontManager.headline)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(AppColors.primaryBlue)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
