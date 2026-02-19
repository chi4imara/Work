import SwiftUI

struct AddMealView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var mealPlanViewModel: MealPlanViewModel
    
    @State private var selectedRecipeId: UUID?
    @State private var selectedMealTime: MealTime = .breakfast
    @State private var searchText = ""
    
    private var availableRecipes: [Recipe] {
        let recipes = Recipe.sampleRecipes
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private var selectedRecipe: Recipe? {
        guard let selectedRecipeId = selectedRecipeId else { return nil }
        return availableRecipes.first { $0.id == selectedRecipeId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        TextField("Search recipes...", text: $searchText)
                            .font(FontManager.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Meal Time")
                            .font(FontManager.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(MealTime.allCases, id: \.self) { mealTime in
                                    MealTimeButton(
                                        mealTime: mealTime,
                                        isSelected: selectedMealTime == mealTime,
                                        action: { selectedMealTime = mealTime }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(availableRecipes) { recipe in
                                AddMealRecipeCard(
                                    recipeId: recipe.id,
                                    isSelected: selectedRecipeId == recipe.id,
                                    onSelect: { selectedRecipeId = recipe.id }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Button(action: addMeal) {
                        Text("Add to Plan")
                            .font(FontManager.ubuntu(18, weight: .medium))
                            .foregroundColor(selectedRecipeId != nil ? ColorTheme.buttonText : ColorTheme.secondaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(selectedRecipeId != nil ? ColorTheme.buttonBackground : ColorTheme.cardBackground)
                            .cornerRadius(25)
                    }
                    .disabled(selectedRecipeId == nil)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.accentText)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func addMeal() {
        guard let recipe = selectedRecipe else { return }
        mealPlanViewModel.addMeal(recipe, mealTime: selectedMealTime)
        dismiss()
    }
}

struct MealTimeButton: View {
    let mealTime: MealTime
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: mealTime.icon)
                    .font(.system(size: 16))
                
                Text(mealTime.rawValue)
                    .font(FontManager.ubuntu(14, weight: .medium))
            }
            .foregroundColor(isSelected ? ColorTheme.buttonText : ColorTheme.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? ColorTheme.buttonBackground : ColorTheme.cardBackground)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(ColorTheme.primaryYellow, lineWidth: isSelected ? 0 : 1)
            )
        }
    }
}

struct AddMealRecipeCard: View {
    let recipeId: UUID
    let isSelected: Bool
    let onSelect: () -> Void
    
    private var recipe: Recipe? {
        Recipe.sampleRecipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        if let recipe = recipe {
            Button(action: onSelect) {
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(recipe.mood.color.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: recipe.mood.icon)
                                .font(.system(size: 24))
                                .foregroundColor(recipe.mood.color)
                        )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(recipe.name)
                            .font(FontManager.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        HStack {
                            Label("\(recipe.calories)", systemImage: "flame.fill")
                                .font(FontManager.ubuntu(12, weight: .regular))
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            Label("\(recipe.cookingTime)m", systemImage: "clock.fill")
                                .font(FontManager.ubuntu(12, weight: .regular))
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            Spacer()
                            
                            Text(recipe.energyLevel.rawValue)
                                .font(FontManager.ubuntu(10, weight: .medium))
                                .foregroundColor(ColorTheme.buttonText)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(recipe.energyLevel.color)
                                .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(ColorTheme.accentGreen)
                    }
                }
                .padding(16)
                .background(isSelected ? ColorTheme.cardBackground.opacity(0.8) : ColorTheme.cardBackground)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? ColorTheme.accentGreen : ColorTheme.cardBorder, lineWidth: isSelected ? 2 : 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    AddMealView(mealPlanViewModel: MealPlanViewModel())
}
