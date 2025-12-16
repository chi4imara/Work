import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var selectedCategory: RecipeCategory?
    @State private var showAddRecipe = false
    
    private var categoriesWithCounts: [(category: RecipeCategory, count: Int)] {
        recipeManager.getCategoriesWithCounts()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Categories")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if categoriesWithCounts.isEmpty {
                    EmptyStateView(
                        icon: "square.grid.2x2",
                        title: "No Categories",
                        message: "Categories are not loaded yet"
                    )
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(categoriesWithCounts, id: \.category) { item in
                                CategoryCardView(
                                    category: item.category,
                                    count: item.count
                                ) {
                                    selectedCategory = item.category
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryRecipesView(category: category)
                .environmentObject(recipeManager)
        }
        .sheet(isPresented: $showAddRecipe) {
            AddRecipeView()
                .environmentObject(recipeManager)
        }
    }
}

struct CategoryCardView: View {
    let category: RecipeCategory
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                Image(systemName: category.icon)
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(category.color)
                
                VStack(spacing: 4) {
                    Text(category.rawValue)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("\(count) recipes")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryRecipesView: View {
    let category: RecipeCategory
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var selectedRecipe: Recipe?
    @Environment(\.dismiss) private var dismiss
    
    private var recipes: [Recipe] {
        recipeManager.getRecipes(for: category)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(recipes) { recipe in
                            RecipeCardView(recipe: recipe) {
                                selectedRecipe = recipe
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
            }
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipeId: recipe.id)
                    .environmentObject(recipeManager)
            }
        }
    }
}

extension RecipeCategory: Identifiable {
    var id: String { self.rawValue }
}

#Preview {
    CategoriesView()
        .environmentObject(RecipeManager())
}
