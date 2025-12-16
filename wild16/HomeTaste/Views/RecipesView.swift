import SwiftUI

enum RecipesSheetItem: Identifiable {
    case addRecipe(Recipe?)
    case recipeDetail(UUID)
    
    var id: String {
        switch self {
        case .addRecipe(let recipe):
            return "addRecipe-\(recipe?.id.uuidString ?? "new")"
        case .recipeDetail(let id):
            return "recipeDetail-\(id.uuidString)"
        }
    }
}

struct RecipesView: View {
    @EnvironmentObject var recipeStore: RecipeStore
    @EnvironmentObject var noteStore: NoteStore
    @State private var sheetItem: RecipesSheetItem?
    @State private var showingDeleteAlert = false
    @State private var recipeToDelete: Recipe?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("My Recipes")
                                    .font(FontManager.title1)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Homemade ideas worth repeating")
                                    .font(FontManager.caption1)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                sheetItem = .addRecipe(nil)
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .medium))
                                    Text("New Recipe")
                                        .font(FontManager.callout)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(AppColors.primaryBlue)
                                .cornerRadius(20)
                            }
                        }
                        
                        SearchBar(text: $recipeStore.searchText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if recipeStore.filteredRecipes.isEmpty {
                        EmptyRecipesView {
                            sheetItem = .addRecipe(nil)
                        }
                    } else {
                        RecipesList(
                            recipes: recipeStore.filteredRecipes,
                            onRecipeTap: { recipe in
                                sheetItem = .recipeDetail(recipe.id)
                            },
                            onRecipeEdit: { recipe in
                                sheetItem = .addRecipe(recipe)
                            },
                            onRecipeDelete: { recipe in
                                recipeToDelete = recipe
                                showingDeleteAlert = true
                            }
                        )
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addRecipe(let recipe):
                AddEditRecipeView(recipe: recipe, category: nil) { updatedRecipe in
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
                .font(.system(size: 16))
            
            TextField("Search by title or ingredients", text: $text)
                .font(FontManager.body)
                .foregroundColor(AppColors.textPrimary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.cardGradient)
        .cornerRadius(25)
    }
}

struct EmptyRecipesView: View {
    let onAddRecipe: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                
                VStack(spacing: 8) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Image(systemName: "fork.knife")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            
            VStack(spacing: 12) {
                Text("Add your first recipe")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Let it be the beginning of your homemade collection.")
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
            .padding(.bottom, 8)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct RecipesList: View {
    let recipes: [Recipe]
    let onRecipeTap: (Recipe) -> Void
    let onRecipeEdit: (Recipe) -> Void
    let onRecipeDelete: (Recipe) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(recipes) { recipe in
                    RecipeCard(
                        recipe: recipe,
                        onTap: { onRecipeTap(recipe) },
                        onEdit: { onRecipeEdit(recipe) },
                        onDelete: { onRecipeDelete(recipe) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.8))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "fork.knife")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(recipe.title)
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.textPrimary)
                            .multilineTextAlignment(.leading)
                        
                        if let categoryName = recipe.category,
                           let category = RecipeCategory.allCategories.first(where: { $0.rawValue == categoryName }) {
                            HStack(spacing: 4) {
                                Image(systemName: category.icon)
                                    .font(.system(size: 10))
                                    .foregroundColor(category.color)
                                Text(categoryName)
                                    .font(FontManager.caption2)
                                    .foregroundColor(category.color)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(category.color.opacity(0.15))
                            .cornerRadius(8)
                        }
                    }
                    
                    if !recipe.shortDescription.isEmpty {
                        Text(recipe.shortDescription)
                            .font(FontManager.caption1)
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(2)
                    }
                    
                    Text(dateFormatter.string(from: recipe.dateModified))
                        .font(FontManager.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            .tint(AppColors.primaryBlue)
        }
    }
}
