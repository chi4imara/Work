import SwiftUI

struct RecipeID: Identifiable {
    let id: UUID
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showingFilters = false
    @State private var showingAddMeal = false
    @State private var selectedRecipeId: RecipeID?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Text("What to cook today?")
                            .font(FontManager.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { showingFilters = true }) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                Text("Filters")
                                    .font(FontManager.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorTheme.secondaryButtonText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(ColorTheme.secondaryButtonBackground)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.top, 20)
                    
                    if viewModel.filteredRecipes.isEmpty {
                        EmptyStateView(
                            title: "No recipes found",
                            subtitle: "No recipes match your current mood",
                            buttonTitle: "Reset Filters",
                            action: { viewModel.clearFilters() }
                        )
                        .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                RecipeCard(
                                    recipeId: recipe.id,
                                    viewModel: viewModel,
                                    isSaved: viewModel.isRecipeSaved(recipe),
                                    onSave: { viewModel.toggleSaveRecipe(recipe) },
                                    onTap: {
                                        selectedRecipeId = RecipeID(id: recipe.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddMeal) {
            AddMealView(mealPlanViewModel: appState.mealPlanViewModel)
        }
        .sheet(item: $selectedRecipeId) { recipeID in
            RecipeDetailView(recipeId: recipeID.id)
                .environmentObject(appState)
        }
    }
}

struct RecipeCard: View {
    let recipeId: UUID
    let viewModel: HomeViewModel
    let isSaved: Bool
    let onSave: () -> Void
    let onTap: () -> Void
    
    private var recipe: Recipe? {
        viewModel.recipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        if let recipe = recipe {
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(recipe.mood.color.opacity(0.3))
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: recipe.mood.icon)
                            .font(.system(size: 30))
                            .foregroundColor(recipe.mood.color)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(FontManager.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(2)
                    
                    HStack {
                        Label("\(recipe.calories)", systemImage: "flame.fill")
                            .font(FontManager.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Spacer()
                        
                        Label("\(recipe.cookingTime)m", systemImage: "clock.fill")
                            .font(FontManager.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    HStack {
                        Text(recipe.energyLevel.rawValue)
                            .font(FontManager.ubuntu(10, weight: .medium))
                            .foregroundColor(ColorTheme.buttonText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(recipe.energyLevel.color)
                            .cornerRadius(8)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
            )
            .onTapGesture {
                onTap()
            }
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(FontManager.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(subtitle)
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Text(buttonTitle)
                    .font(FontManager.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.buttonText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(ColorTheme.buttonBackground)
                    .cornerRadius(20)
            }
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    HomeView()
}
