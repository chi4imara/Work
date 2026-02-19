import SwiftUI

struct MeatTypeItem: Identifiable {
    let id = UUID()
    let meatType: String
}

struct MeatTypesView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var selectedMeatTypeItem: MeatTypeItem?
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Meat Types")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.vertical, 10)
                
                if recipeViewModel.recipes.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text("Categories not created yet.")
                            .font(.playfairDisplay(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(recipeViewModel.getMeatTypesWithCounts(), id: \.type) { meatTypeData in
                                MeatTypeCard(
                                    meatType: meatTypeData.type,
                                    recipeCount: meatTypeData.count
                                ) {
                                    selectedMeatTypeItem = MeatTypeItem(meatType: meatTypeData.type)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedMeatTypeItem) { item in
            MeatTypeRecipesView(
                meatType: item.meatType,
                recipes: recipeViewModel.getRecipesForMeatType(item.meatType),
                onRecipeSelected: { recipe in
                    selectedRecipe = recipe
                    selectedMeatTypeItem = nil
                }
            )
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailsView(
                recipeId: recipe.id,
                recipeViewModel: recipeViewModel
            )
        }
    }
}

struct MeatTypeCard: View {
    let meatType: String
    let recipeCount: Int
    let onTap: () -> Void
    
    private func getIconForMeatType(_ type: String) -> String {
        switch type.lowercased() {
        case "beef":
            return "leaf.fill"
        case "chicken":
            return "bird.fill"
        case "pork":
            return "circle.fill"
        case "fish":
            return "fish.fill"
        case "vegetables":
            return "carrot.fill"
        default:
            return "fork.knife"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: getIconForMeatType(meatType))
                        .font(.system(size: 24))
                        .foregroundColor(ColorManager.orange)
                }
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(ColorManager.orange.opacity(0.1))
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(meatType)
                        .font(.playfairDisplay(size: 20, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text("\(recipeCount) recipe\(recipeCount == 1 ? "" : "s")")
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                Text("Open")
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.lightBlue.opacity(0.2))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ColorManager.lightBlue, lineWidth: 1)
                            }
                    )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.secondaryBackground.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                    }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MeatTypeRecipesView: View {
    @Environment(\.dismiss) var dismiss
    let meatType: String
    let recipes: [Recipe]
    let onRecipeSelected: (Recipe) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Close") {
                            dismiss()
                        }
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.lightBlue)
                        
                        Spacer()
                        
                        Text(meatType)
                            .font(.playfairDisplay(size: 24, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Text("Close")
                            .font(.playfairDisplay(size: 16, weight: .medium))
                            .foregroundColor(Color.clear)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(recipes) { recipe in
                                MeatTypeRecipeCard(recipe: recipe) {
                                    onRecipeSelected(recipe)
                                    dismiss()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct MeatTypeRecipeCard: View {
    let recipe: Recipe
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.dishName)
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                        .lineLimit(1)
                    
                    Label("\(recipe.cookingTime) min", systemImage: "clock.fill")
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                Text("Open")
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.lightBlue.opacity(0.2))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ColorManager.lightBlue, lineWidth: 1)
                            }
                    )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.secondaryBackground.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                    }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MeatTypesView(recipeViewModel: {
        let vm = RecipeViewModel()
        vm.recipes = [
            Recipe(dishName: "Ribeye Steak", meatType: "Beef", cookingTime: "12", sauceMarinate: "BBQ", cookingStep: "Grill", comment: ""),
            Recipe(dishName: "BBQ Wings", meatType: "Chicken", cookingTime: "25", sauceMarinate: "Buffalo", cookingStep: "Grill", comment: ""),
            Recipe(dishName: "Pork Ribs", meatType: "Pork", cookingTime: "45", sauceMarinate: "Dry Rub", cookingStep: "Slow cook", comment: "")
        ]
        return vm
    }())
}
