import SwiftUI

struct RecipeSavedView: View {
    let recipe: Recipe
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.success)
                        
                        Text("Recipe Saved")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 20) {
                        RecipeDetailRow(title: "Dish Name", value: recipe.dishName)
                        RecipeDetailRow(title: "Meat Type", value: recipe.meatType)
                        RecipeDetailRow(title: "Cooking Time", value: "\(recipe.cookingTime) min")
                        RecipeDetailRow(title: "Sauce / Marinade", value: recipe.sauceMarinate)
                        RecipeDetailRow(title: "Cooking Step", value: recipe.cookingStep)
                        RecipeDetailRow(
                            title: "Comment",
                            value: recipe.comment.isEmpty ? "No comment added." : recipe.comment
                        )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ColorManager.secondaryBackground.opacity(0.8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                            }
                    )
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        appViewModel.hideRecipeSavedScreen()
                    }) {
                        Text("Done")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorManager.accentGradient)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer(minLength: 50)
                }
            }
        }
    }
}

struct RecipeDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 14, weight: .semibold))
                .foregroundColor(ColorManager.lightBlue)
            
            Text(value)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(ColorManager.primaryText)
                .lineLimit(nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    RecipeSavedView(
        recipe: Recipe(
            dishName: "Ribeye Steak",
            meatType: "Beef",
            cookingTime: "12",
            sauceMarinate: "Classic BBQ",
            cookingStep: "Grill on high heat for 2 minutes each side",
            comment: "Best cooked medium rare"
        ),
        appViewModel: AppViewModel()
    )
}
