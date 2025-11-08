import SwiftUI

struct RecipesListView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State private var showingAddRecipe = false
    @State private var showingSearch = false
    @State private var showingMenu = false
    @State private var showingClearAlert = false
    @State private var showingHowItWorks = false
    @State private var selectedRecipe: Recipe?
    @State private var editingRecipe: Recipe?
    
    var body: some View {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if showingSearch {
                        searchBarView
                    }
                    
                    if showingSearch {
                        categoryFiltersView
                    }
                    
                    if viewModel.recipes.isEmpty {
                        emptyStateView
                    } else if viewModel.filteredRecipes.isEmpty && (!viewModel.searchText.isEmpty || viewModel.selectedCategory != nil) {
                        noResultsView
                    } else {
                        recipesListView
                    }
                }
            }
        .sheet(isPresented: $showingAddRecipe) {
            AddEditRecipeView(viewModel: viewModel)
        }
        .sheet(item: $editingRecipe) { recipe in
            AddEditRecipeView(viewModel: viewModel, editingRecipe: recipe)
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipeId: recipe.id, viewModel: viewModel)
        }
        .sheet(isPresented: $showingHowItWorks) {
            HowItWorksView()
        }
        .alert("Clear All Recipes", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.clearAllRecipes()
            }
        } message: {
            Text("Delete all recipes? Data will be lost.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Recipes")
                .font(.ubuntuTitle)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingSearch.toggle()
                        if !showingSearch {
                            viewModel.clearFilters()
                        }
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(.textPrimary)
                }
                
                Button(action: {
                    showingAddRecipe = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        .foregroundColor(.textPrimary)
                }
                
                Menu {
                    Button("Clear All Recipes") {
                        showingClearAlert = true
                    }
                    Button("How It Works") {
                        showingHowItWorks = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
            
            TextField("Search recipes and ingredients...", text: $viewModel.searchText)
                .font(.ubuntuBody)
                .foregroundColor(.textPrimary)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var categoryFiltersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    viewModel.selectedCategory = nil
                }
                
                ForEach(RecipeCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.displayName,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        if viewModel.selectedCategory == category {
                            viewModel.selectedCategory = nil
                        } else {
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 80))
                .foregroundColor(.textSecondary)
            
            Text("Add Your First Recipe")
                .font(.ubuntuHeadline)
                .foregroundColor(.textPrimary)
            
            Button(action: {
                showingAddRecipe = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Recipe")
                        .font(.ubuntuSubheadline)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.primaryPurple)
                .cornerRadius(12)
            }
            
            Spacer()
        }
    }
    
    private var noResultsView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("Nothing Found")
                .font(.ubuntuHeadline)
                .foregroundColor(.textPrimary)
            
            Button("Reset Filters") {
                viewModel.clearFilters()
            }
            .font(.ubuntuSubheadline)
            .foregroundColor(.primaryPurple)
            
            Spacer()
        }
    }
    
    private var recipesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredRecipes) { recipe in
                    RecipeCard(recipe: recipe, viewModel: viewModel) {
                        selectedRecipe = recipe
                    }
                    .contextMenu {
                        Button("Edit") {
                            editingRecipe = recipe
                        }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteRecipe(recipe)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button("Edit") {
                            editingRecipe = recipe
                        }
                        .tint(.accentOrange)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete") {
                            viewModel.deleteRecipe(recipe)
                        }
                        .tint(.accentRed)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntuCaption)
                .foregroundColor(isSelected ? .white : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.primaryPurple : Color.cardBackground
                )
                .cornerRadius(20)
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Text(recipe.title)
                        .font(.ubuntuHeadline)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleFavorite(for: recipe)
                    }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(recipe.isFavorite ? .red : .textSecondary)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text(recipe.category.displayName)
                    .font(.ubuntuCaption)
                    .foregroundColor(.textSecondary)
                
                HStack {
                    if !recipe.ingredients.isEmpty {
                        Text(recipe.ingredients.prefix(3).joined(separator: ", ") + (recipe.ingredients.count > 3 ? "..." : ""))
                            .font(.ubuntuBody)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    
                    Text(formatDate(recipe.updatedAt))
                        .font(.ubuntuSmall)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}


