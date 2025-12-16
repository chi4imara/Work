import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var selectedRecipe: Recipe?
    @State private var recipeToEdit: Recipe?
    
    private var recipesWithDates: [Recipe] {
        recipeManager.getAllRecipesWithDates()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("History")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if recipesWithDates.isEmpty {
                    EmptyStateView(
                        icon: "clock",
                        title: "No History Yet",
                        message: "Recipe history is still empty"
                    )
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(recipesWithDates) { recipe in
                                HistoryCardView(recipe: recipe) {
                                    selectedRecipe = recipe
                                }
                                .contextMenu {
                                    Button {
                                        recipeToEdit = recipe
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipeId: recipe.id)
                .environmentObject(recipeManager)
        }
        .sheet(item: $recipeToEdit) { recipe in
            EditRecipeView(recipe: recipe)
                .environmentObject(recipeManager)
        }
    }
}

struct HistoryCardView: View {
    let recipe: Recipe
    let onTap: () -> Void
    
    private var formattedDate: String {
        if let date = recipe.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        } else {
            return "No date"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(formattedDate)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text(recipe.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: recipe.category.icon)
                                .font(.system(size: 12))
                                .foregroundColor(recipe.category.color)
                            
                            Text(recipe.category.rawValue)
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text("\(recipe.cookingTime) min")
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                }
                
                Spacer()
                
                RecipeThumbnailView(recipe: recipe)
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
            }
            .padding()
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HistoryView()
        .environmentObject(RecipeManager())
}
