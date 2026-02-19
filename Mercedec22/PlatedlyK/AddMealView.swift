import SwiftUI

struct AddMealView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    var initialCategory: Recipe.MealCategory = .breakfast
    let onAddMeal: (Recipe, Recipe.MealCategory) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCategory: Recipe.MealCategory = .breakfast
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    categorySelector
                    
                    searchBar
                    
                    ScrollView {
                        if recipeViewModel.recipes.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "book.closed")
                                    .font(.system(size: 44))
                                    .foregroundColor(AppColors.textSecondary)
                                Text("No recipes yet")
                                    .font(AppFonts.subtitle(18))
                                    .foregroundColor(AppColors.textPrimary)
                                Text("Add recipes on the Home tab (tap +) or load sample data in Settings.")
                                    .font(AppFonts.body(14))
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
                                ForEach(filteredRecipes) { recipe in
                                    AddMealRecipeCard(recipe: recipe) {
                                        onAddMeal(recipe, selectedCategory)
                                        dismiss()
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .onAppear {
                        selectedCategory = initialCategory
                    }
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle("Add Meal")
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
                    dismiss()
                }
                .foregroundColor(AppColors.primaryYellow)
            }
        }
    }
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Recipe.MealCategory.allCases, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category.rawValue)
                            .font(AppFonts.body(14))
                            .foregroundColor(selectedCategory == category ? .black : AppColors.textPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedCategory == category ? AppColors.primaryYellow : AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedCategory == category ? AppColors.primaryYellow : AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search recipes...", text: $searchText)
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.textPrimary)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
    }
    
    private var filteredRecipes: [Recipe] {
        var filtered = recipeViewModel.recipes
        
        filtered.sort { recipe1, recipe2 in
            let recipe1Matches = recipe1.category == selectedCategory
            let recipe2Matches = recipe2.category == selectedCategory
            
            if recipe1Matches && !recipe2Matches {
                return true
            } else if !recipe1Matches && recipe2Matches {
                return false
            } else {
                return recipe1.name < recipe2.name
            }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        return filtered
    }
}

struct AddMealRecipeCard: View {
    let recipe: Recipe
    let onAdd: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(AppFonts.subtitle(14))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                
                HStack {
                    Label("\(recipe.cookingTime)m", systemImage: "clock")
                    Spacer()
                    Label("\(recipe.calories)", systemImage: "flame")
                }
                .font(AppFonts.caption(10))
                .foregroundColor(AppColors.textSecondary)
                
                HStack {
                    Text(recipe.difficulty.rawValue)
                        .font(AppFonts.caption(8))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(difficultyColor(recipe.difficulty))
                        )
                    
                    Spacer()
                    
                    if recipe.category != Recipe.MealCategory.allCases.first {
                        Text(recipe.category.rawValue)
                            .font(AppFonts.caption(8))
                            .foregroundColor(AppColors.textAccent)
                    }
                }
            }
            
            Button(action: onAdd) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 12))
                    Text("Add")
                        .font(AppFonts.button(12))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.primaryYellow)
                )
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func difficultyColor(_ difficulty: Recipe.Difficulty) -> Color {
        switch difficulty {
        case .beginner:
            return AppColors.secondaryGreen
        case .intermediate:
            return AppColors.secondaryOrange
        case .advanced:
            return AppColors.secondaryPink
        }
    }
}

#Preview {
    AddMealView(recipeViewModel: RecipeViewModel(), onAddMeal: { _, _ in })
}
