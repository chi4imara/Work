import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    static let shared = RecipeViewModel()
    
    @Published var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    @Published var selectedTags: [String] = []
    @Published var currentSortOption: SortOption = .recentlyAdded
    @Published var selectedTimeFilter: TimeFilter? = nil
    @Published var selectedDifficultyFilter: Recipe.Difficulty? = nil
    @Published var selectedServingsFilter: ServingsFilter? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        print("🚀 RecipeViewModel: Initializing...")
        setupBindings()
        loadRecipes()
        print("✅ RecipeViewModel: Initialized with \(recipes.count) recipes")
    }
    
    private func setupBindings() {
        dataManager.$recipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
                print("🔄 RecipeViewModel: Received \(recipes.count) recipes from DataManager")
                self?.recipes = recipes
                self?.applyFiltersAndSort()
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest4(
            $searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main),
            $showFavoritesOnly,
            $selectedTags,
            Publishers.CombineLatest3($selectedTimeFilter, $selectedDifficultyFilter, $selectedServingsFilter)
        )
        .sink { [weak self] searchText, showFavoritesOnly, selectedTags, _ in
            print("🔍 RecipeViewModel: Combine triggered - searchText: '\(searchText)', showFavoritesOnly: \(showFavoritesOnly), selectedTags: \(selectedTags)")
            self?.applyFiltersAndSort()
        }
        .store(in: &cancellables)
        
        $currentSortOption
            .sink { [weak self] _ in
                self?.applyFiltersAndSort()
            }
            .store(in: &cancellables)
    }
    
    func loadRecipes() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    
    func addRecipe(_ recipe: Recipe) {
        dataManager.addRecipe(recipe)
    }
    
    func updateRecipe(_ recipe: Recipe) {
        dataManager.updateRecipe(recipe)
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        dataManager.deleteRecipe(recipe)
    }
    
    func toggleRecipeFavorite(_ recipe: Recipe) {
        dataManager.toggleRecipeFavorite(recipe)
    }
    
    func duplicateRecipe(_ recipe: Recipe) -> Recipe {
        return dataManager.duplicateRecipe(recipe)
    }
    
    func applyFiltersAndSort() {
        print("🔍 RecipeViewModel: Applying filters - showFavoritesOnly: \(showFavoritesOnly), selectedTags: \(selectedTags), searchText: '\(searchText)'")
        
        let filtered = dataManager.searchRecipes(
            query: searchText,
            showFavoritesOnly: showFavoritesOnly,
            selectedTags: selectedTags,
            timeFilter: selectedTimeFilter,
            difficultyFilter: selectedDifficultyFilter,
            servingsFilter: selectedServingsFilter
        )
        
        print("🔍 RecipeViewModel: Filtered \(filtered.count) recipes from \(recipes.count) total")
        if showFavoritesOnly {
            let favorites = recipes.filter { $0.isFavorite }
            print("🔍 RecipeViewModel: Found \(favorites.count) favorite recipes")
        }
        
        filteredRecipes = dataManager.sortRecipes(filtered, by: currentSortOption)
    }
    
    func clearAllFilters() {
        searchText = ""
        showFavoritesOnly = false
        selectedTags.removeAll()
        selectedTimeFilter = nil
        selectedDifficultyFilter = nil
        selectedServingsFilter = nil
    }
    
    func toggleTagFilter(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.removeAll { $0 == tag }
        } else {
            selectedTags.append(tag)
        }
    }
    
    func setSortOption(_ option: SortOption) {
        currentSortOption = option
    }
    
    var availableTags: [String] {
        let allTags = Set(recipes.flatMap { $0.tags })
        return Array(allTags).sorted()
    }
    
    var hasActiveFilters: Bool {
        return !searchText.isEmpty ||
               showFavoritesOnly ||
               !selectedTags.isEmpty ||
               selectedTimeFilter != nil ||
               selectedDifficultyFilter != nil ||
               selectedServingsFilter != nil
    }
    
    var isEmpty: Bool {
        return filteredRecipes.isEmpty
    }
    
    var isEmptyState: Bool {
        return recipes.isEmpty
    }
}
