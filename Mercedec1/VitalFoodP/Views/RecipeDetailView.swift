import SwiftUI

struct RecipeDetailView: View {
    let recipeId: UUID
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMealTime: MealTime = .breakfast
    @State private var showingAddToPlan = false
    
    private var recipe: Recipe? {
        viewModel.recipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let recipe = recipe {
                    ScrollView {
                        VStack(spacing: 24) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(recipe.mood.color.opacity(0.3))
                                .frame(height: 200)
                                .overlay(
                                    VStack(spacing: 16) {
                                        Image(systemName: recipe.mood.icon)
                                            .font(.system(size: 60))
                                            .foregroundColor(recipe.mood.color)
                                        
                                        Text(recipe.mood.rawValue)
                                            .font(FontManager.ubuntu(18, weight: .medium))
                                            .foregroundColor(ColorTheme.primaryText)
                                    }
                                )
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text(recipe.name)
                                    .font(FontManager.ubuntu(28, weight: .bold))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                HStack(spacing: 24) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Calories")
                                            .font(FontManager.ubuntu(12, weight: .regular))
                                            .foregroundColor(ColorTheme.secondaryText)
                                        Text("\(recipe.calories)")
                                            .font(FontManager.ubuntu(20, weight: .bold))
                                            .foregroundColor(ColorTheme.accentText)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Time")
                                            .font(FontManager.ubuntu(12, weight: .regular))
                                            .foregroundColor(ColorTheme.secondaryText)
                                        Text("\(recipe.cookingTime)m")
                                            .font(FontManager.ubuntu(20, weight: .bold))
                                            .foregroundColor(ColorTheme.accentText)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Energy")
                                            .font(FontManager.ubuntu(12, weight: .regular))
                                            .foregroundColor(ColorTheme.secondaryText)
                                        Text(recipe.energyLevel.rawValue)
                                            .font(FontManager.ubuntu(20, weight: .bold))
                                            .foregroundColor(recipe.energyLevel.color)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Divider()
                                    .background(ColorTheme.cardBorder)
                                
                                HStack {
                                    Text("Category:")
                                        .font(FontManager.ubuntu(16, weight: .medium))
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Text(recipe.category)
                                        .font(FontManager.ubuntu(16, weight: .regular))
                                        .foregroundColor(ColorTheme.secondaryText)
                                    
                                    Spacer()
                                }
                                
                                Button(action: {
                                    viewModel.toggleSaveRecipe(recipe)
                                }) {
                                    HStack {
                                        Image(systemName: viewModel.isRecipeSaved(recipe) ? "heart.fill" : "heart")
                                            .font(.system(size: 18))
                                        Text(viewModel.isRecipeSaved(recipe) ? "Saved" : "Save Recipe")
                                            .font(FontManager.ubuntu(16, weight: .medium))
                                    }
                                    .foregroundColor(viewModel.isRecipeSaved(recipe) ? ColorTheme.buttonText : ColorTheme.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(viewModel.isRecipeSaved(recipe) ? ColorTheme.accentOrange : ColorTheme.cardBackground)
                                    .cornerRadius(25)
                                }
                                
                                Button(action: {
                                    showingAddToPlan = true
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 18))
                                        Text("Add to Meal Plan")
                                            .font(FontManager.ubuntu(16, weight: .medium))
                                    }
                                    .foregroundColor(ColorTheme.buttonText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(ColorTheme.buttonBackground)
                                    .cornerRadius(25)
                                    .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 100)
                    }
                } else {
                    VStack {
                        Text("Recipe not found")
                            .font(FontManager.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                }
            }
            .navigationTitle("Recipe Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.accentText)
                }
            }
        }
        .sheet(isPresented: $showingAddToPlan) {
            AddMealToPlanView(recipeId: recipeId, mealPlanViewModel: appState.mealPlanViewModel)
        }
        .preferredColorScheme(.dark)
    }
}

struct AddMealToPlanView: View {
    let recipeId: UUID
    @ObservedObject var mealPlanViewModel: MealPlanViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMealTime: MealTime = .breakfast
    
    private var recipe: Recipe? {
        Recipe.sampleRecipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 30) {
                    if let recipe = recipe {
                        HStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(recipe.mood.color.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: recipe.mood.icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(recipe.mood.color)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(recipe.name)
                                    .font(FontManager.ubuntu(18, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Text("\(recipe.calories) cal • \(recipe.cookingTime)m")
                                    .font(FontManager.ubuntu(14, weight: .regular))
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Select Meal Time")
                                .font(FontManager.ubuntu(20, weight: .medium))
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
                        
                        Spacer()
                        
                        Button(action: {
                            mealPlanViewModel.addMeal(recipe, mealTime: selectedMealTime)
                            dismiss()
                        }) {
                            Text("Add to Plan")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(ColorTheme.buttonBackground)
                                .cornerRadius(25)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Add to Meal Plan")
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
}

#Preview {
    RecipeDetailView(recipeId: Recipe.sampleRecipes.first!.id)
        .environmentObject(AppState())
}
