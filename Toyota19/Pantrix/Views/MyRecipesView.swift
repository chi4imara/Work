import SwiftUI

struct MyRecipesView: View {
    @ObservedObject var appState: AppState
    @State private var showingAddRecipe = false
    @State private var selectedRecipeDestination: RecipeDetailDestination?
    @State private var searchText = ""
    @State private var selectedCategory: Recipe.RecipeCategory?
    @State private var showingFavoritesOnly = false
    
    private var filteredRecipes: [Recipe] {
        var recipes = appState.recipes
        
        if showingFavoritesOnly {
            recipes = recipes.filter { $0.isFavorite }
        }
        
        if let category = selectedCategory {
            recipes = recipes.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            recipes = recipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.joined().localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return recipes
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("My Recipes")
                            .font(.appTitle)
                            .foregroundColor(.appWhite)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddRecipe = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.appWhite)
                                .frame(width: 44, height: 44)
                                .background(Color.appOrange)
                                .clipShape(Circle())
                        }
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.appWhite.opacity(0.6))
                        
                        TextField("Search recipes...", text: $searchText)
                            .font(.appBody)
                            .foregroundColor(.appWhite)
                    }
                    .padding(12)
                    .background(Color.appWhite.opacity(0.1))
                    .cornerRadius(12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Button(action: {
                                showingFavoritesOnly.toggle()
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: showingFavoritesOnly ? "heart.fill" : "heart")
                                        .font(.appCaption)
                                    Text("Favorites")
                                        .font(.appCaption)
                                }
                                .foregroundColor(showingFavoritesOnly ? .appWhite : .appWhite.opacity(0.7))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    showingFavoritesOnly ?
                                    Color.appRed : Color.appWhite.opacity(0.1)
                                )
                                .cornerRadius(16)
                            }
                            
                            Button(action: {
                                selectedCategory = nil
                            }) {
                                Text("All")
                                    .font(.appCaption)
                                    .foregroundColor(selectedCategory == nil ? .appWhite : .appWhite.opacity(0.7))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        selectedCategory == nil ?
                                        Color.appOrange : Color.appWhite.opacity(0.1)
                                    )
                                    .cornerRadius(16)
                            }
                            
                            ForEach(Recipe.RecipeCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }) {
                                    Text(category.displayName)
                                        .font(.appCaption)
                                        .foregroundColor(selectedCategory == category ? .appWhite : .appWhite.opacity(0.7))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            selectedCategory == category ?
                                            Color.appOrange : Color.appWhite.opacity(0.1)
                                        )
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, -20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if filteredRecipes.isEmpty {
                    EmptyRecipesView(
                        showingAddRecipe: $showingAddRecipe,
                        hasFilters: !searchText.isEmpty || selectedCategory != nil || showingFavoritesOnly
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRecipes) { recipe in
                                    RecipeListCard(
                                        recipe: recipe,
                                        onFavoriteToggle: {
                                            appState.toggleFavorite(for: recipe)
                                        },
                                        onCookedToggle: {
                                            if recipe.isCooked {
                                                appState.unmarkAsCooked(recipe)
                                            } else {
                                                appState.markAsCooked(recipe)
                                            }
                                        },
                                        onTap: {
                                            selectedRecipeDestination = RecipeDetailDestination(id: recipe.id)
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddRecipe) {
            AddRecipeView(appState: appState)
        }
        .sheet(item: $selectedRecipeDestination) { destination in
            RecipeDetailView(recipeId: destination.id, appState: appState)
        }
    }
}

struct RecipeListCard: View {
    let recipe: Recipe
    let onFavoriteToggle: () -> Void
    let onCookedToggle: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.appHeadline)
                        .foregroundColor(.appWhite)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "clock")
                            .font(.appCaption)
                            .foregroundColor(.appOrange)
                        
                        Text("\(recipe.cookingTime) min")
                            .font(.appCaption)
                            .foregroundColor(.appWhite.opacity(0.8))
                        
                        Spacer()
                        
                        Text(recipe.category.displayName)
                            .font(.appCaption2)
                            .foregroundColor(.appOrange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.appOrange.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Text(recipe.ingredients.prefix(3).joined(separator: ", "))
                        .font(.appCaption)
                        .foregroundColor(.appWhite.opacity(0.7))
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: onFavoriteToggle) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.appCallout)
                            .foregroundColor(recipe.isFavorite ? .appRed : .appWhite.opacity(0.6))
                            .frame(width: 32, height: 32)
                    }
                    
                    Button(action: onCookedToggle) {
                        Image(systemName: recipe.isCooked ? "checkmark.circle.fill" : "circle")
                            .font(.appCallout)
                            .foregroundColor(.appWhite)
                            .frame(width: 32, height: 32)
                            .background(recipe.isCooked ? Color.appGreen : Color.appWhite.opacity(0.2))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(recipe.isCooked ? Color.clear : Color.appGreen, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appWhite.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyRecipesView: View {
    @Binding var showingAddRecipe: Bool
    let hasFilters: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: hasFilters ? "magnifyingglass" : "book")
                .font(.system(size: 60))
                .foregroundColor(.appWhite.opacity(0.3))
            
            VStack(spacing: 8) {
                Text(hasFilters ? "No recipes found" : "No recipes yet")
                    .font(.appTitle3)
                    .foregroundColor(.appWhite)
                
                Text(hasFilters ? "Try adjusting your search or filters" : "Add your first recipe and start your energetic day")
                    .font(.appBody)
                    .foregroundColor(.appWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            if !hasFilters {
                Button {
                    showingAddRecipe = true
                } label: {
                    Text("Add First Recipe")
                        .font(.appHeadline)
                        .foregroundColor(.appWhite)
                        .frame(width: 200, height: 50)
                        .background(Color.appOrange)
                        .cornerRadius(25)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    MyRecipesView(appState: AppState())
}
