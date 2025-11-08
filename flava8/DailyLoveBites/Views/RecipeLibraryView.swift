import SwiftUI

struct RecipeLibraryView: View {
    @ObservedObject private var viewModel = RecipeViewModel.shared
    @State private var showingAddRecipe = false
    @State private var showingFilters = false
    @State private var selectedRecipe: Recipe?
    @State private var showingRecipeDetails = false
    @State private var returnTagFilter: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    filtersSection
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.isEmptyState {
                        emptyStateView
                    } else if viewModel.isEmpty {
                        noResultsView
                    } else {
                        recipeListView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddRecipe) {
                AddEditRecipeView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilters) {
                FiltersView(viewModel: viewModel)
            }
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe, viewModel: viewModel) { tagFilter in
                    returnTagFilter = tagFilter
                }
            }
            .onAppear {
                if let tagFilter = returnTagFilter {
                    viewModel.selectedTags = [tagFilter]
                    returnTagFilter = nil
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Recipes")
                    .font(AppFonts.titleLarge)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showingAddRecipe = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.primaryPurple)
                        .clipShape(Circle())
                        .shadow(color: Color.primaryPurple.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondaryText)
                
                TextField("Search recipes...", text: $viewModel.searchText)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.white)
                    .accentColor(.primaryPurple)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var filtersSection: some View {
        VStack(spacing: 12) {
            HStack {
                Picker("Filter", selection: $viewModel.showFavoritesOnly) {
                    Text("All").tag(false)
                    Text("Favorites").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 150)
                .onChange(of: viewModel.showFavoritesOnly) { newValue in
                    print("🔍 RecipeLibraryView: showFavoritesOnly changed to: \(newValue)")
                    viewModel.applyFiltersAndSort()
                }
                
                Spacer()
                
                Menu {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(action: { viewModel.setSortOption(option) }) {
                            HStack {
                                Text(option.displayName)
                                if viewModel.currentSortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Sort")
                            .font(AppFonts.bodySmall)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.availableTags, id: \.self) { tag in
                        TagChip(
                            tag: tag,
                            isSelected: viewModel.selectedTags.contains(tag)
                        ) {
                            viewModel.toggleTagFilter(tag)
                        }
                    }
                    
                    Button(action: { showingFilters = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            Text("Filters")
                                .font(AppFonts.bodySmall)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            viewModel.hasActiveFilters ? Color.primaryPurple : Color.white.opacity(0.2)
                        )
                        .cornerRadius(8)
                    }
                    
                    if viewModel.hasActiveFilters {
                        Button(action: { viewModel.clearAllFilters() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "xmark")
                                Text("Clear")
                                    .font(AppFonts.bodySmall)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                                .background(Color.errorRed.opacity(0.8))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 12)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("Loading recipes...")
                .font(AppFonts.bodyMedium)
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Recipes Yet")
                    .font(AppFonts.titleMedium)
                    .foregroundColor(.white)
                
                Text("Add your first recipe to get started")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddRecipe = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Recipe")
                }
                .font(AppFonts.buttonMedium)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.primaryPurple)
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Results Found")
                    .font(AppFonts.titleMedium)
                    .foregroundColor(.white)
                
                Text("Try adjusting your search or filters")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { viewModel.clearAllFilters() }) {
                Text("Clear Filters")
                    .font(AppFonts.buttonMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.primaryPurple)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var recipeListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredRecipes) { recipe in
                    RecipeCard(recipe: recipe) { action in
                        handleRecipeAction(action, for: recipe)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100) 
        }
    }
    
    private func handleRecipeAction(_ action: RecipeCardAction, for recipe: Recipe) {
        switch action {
        case .tap:
            selectedRecipe = recipe
            showingRecipeDetails = true
        case .toggleFavorite:
            viewModel.toggleRecipeFavorite(recipe)
        case .edit:
            break
        case .delete:
            viewModel.deleteRecipe(recipe)
        }
    }
}

struct TagChip: View {
    let tag: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text("#\(tag)")
                .font(AppFonts.bodySmall)
                .foregroundColor(isSelected ? .white : .primaryPurple)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isSelected ? Color.primaryPurple : Color.white.opacity(0.9)
                )
                .cornerRadius(8)
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    let onAction: (RecipeCardAction) -> Void
    
    @State private var showingActionSheet = false
    
    var body: some View {
        Button(action: { onAction(.tap) }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(recipe.name)
                        .font(AppFonts.titleSmall)
                        .foregroundColor(.darkText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: { onAction(.toggleFavorite) }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(recipe.isFavorite ? .errorRed : .secondaryGray)
                    }
                }
                
                Text(recipe.metadataString)
                    .font(AppFonts.bodySmall)
                    .foregroundColor(.darkGray)
                
                if !recipe.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(recipe.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(AppFonts.caption)
                                    .foregroundColor(.primaryPurple)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.primaryPurple.opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .onLongPressGesture {
            showingActionSheet = true
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text(recipe.name),
                buttons: [
                    .default(Text("Edit")) { onAction(.edit) },
                    .destructive(Text("Delete")) { onAction(.delete) },
                    .cancel()
                ]
            )
        }
    }
}

enum RecipeCardAction {
    case tap
    case toggleFavorite
    case edit
    case delete
}

#Preview {
    RecipeLibraryView()
}
