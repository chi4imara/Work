import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTab: Int
    
    @State private var showingActionSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridOverlay()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    headerView
                        .padding(.top, 10)
                    
                    recipeInfoView
                    
                    ingredientsView
                    
                    stepsView
                    
                    if !recipe.notes.isEmpty {
                        notesView
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text(recipe.name),
                buttons: [
                    .default(Text("Edit")) {
                        recipeViewModel.selectedRecipe = recipe
                        showingEditView = true
                    },
                    .destructive(Text("Delete")) {
                        showingDeleteAlert = true
                    },
                    .cancel()
                ]
            )
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                recipeViewModel.deleteRecipe(recipe)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
        .sheet(isPresented: $showingEditView) {
            AddEditRecipeView(recipeViewModel: recipeViewModel, categoryViewModel: categoryViewModel, selectedTab: $selectedTab)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 40, height: 40)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(20)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            
            Spacer()
            
            Text(recipe.name)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Spacer()
            
            Button(action: {
                showingActionSheet = true
            }) {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 40, height: 40)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(20)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.top, 10)
    }
    
    private var recipeInfoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if !recipe.category.isEmpty {
                    InfoChip(icon: "tag.fill", text: "Category: \(recipe.category)")
                }
                
                Spacer()
                
                if let cookingTime = recipe.cookingTime {
                    InfoChip(icon: "clock.fill", text: "\(cookingTime) min")
                }
            }
            
            HStack {
                InfoChip(icon: "person.fill", text: "Author: you")
                Spacer()
            }
        }
    }
    
    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Ingredients")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 6, height: 6)
                            .padding(.top, 8)
                        
                        Text(ingredient)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.darkGray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(AppColors.backgroundWhite)
            .cornerRadius(15)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    private var stepsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Cooking Steps")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 15) {
                        Text("\(index + 1)")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(AppColors.primaryBlue)
                            .cornerRadius(14)
                        
                        Text(step)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.darkGray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(AppColors.backgroundWhite)
            .cornerRadius(15)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    private var notesView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Notes")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Text(recipe.notes)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.darkGray)
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.backgroundWhite)
                .cornerRadius(15)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    private var backButtonView: some View {
        Button(action: {
            withAnimation {
                selectedTab = 0
            }
        }) {
            Text("Back to Recipe List")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.primaryBlue)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 20)
    }
}

struct InfoChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(AppColors.primaryYellow)
            
            Text(text)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.darkGray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.backgroundWhite)
        .cornerRadius(20)
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}

