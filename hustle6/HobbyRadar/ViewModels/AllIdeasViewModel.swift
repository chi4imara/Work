import Foundation
import Combine

class AllIdeasViewModel: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var filteredIdeas: [Idea] = []
    @Published var selectedCategories: Set<Category> = []
    @Published var sourceFilter: SourceFilter = .all
    @Published var sortOption: SortOption = .dateAdded
    @Published var isAscending = false
    @Published var searchText = ""
    @Published var showingFilters = false
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    var availableCategories: [Category] {
        return dataManager.categories
    }
    
    init() {
        setupBindings()
        loadIdeas()
    }
    
    private func setupBindings() {
        dataManager.$ideas
            .sink { [weak self] _ in
                self?.loadIdeas()
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest4(
            $selectedCategories,
            $sourceFilter,
            $sortOption,
            $isAscending
        )
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] _, _, _, _ in
            self?.applyFilters()
        }
        .store(in: &cancellables)
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
     func loadIdeas() {
        ideas = dataManager.ideas
        applyFilters()
    }
    
    private func applyFilters() {
        let categoryArray = selectedCategories.isEmpty ? nil : Array(selectedCategories)
        
        var filtered = dataManager.getFilteredIdeas(
            categories: categoryArray,
            sourceFilter: sourceFilter,
            sortBy: sortOption,
            ascending: isAscending
        )
        
        if !searchText.isEmpty {
            filtered = filtered.filter { idea in
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.category.name.localizedCaseInsensitiveContains(searchText) ||
                (idea.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        filteredIdeas = filtered
    }
    
    func toggleCategoryFilter(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
    
    func clearFilters() {
        selectedCategories.removeAll()
        sourceFilter = .all
        sortOption = .dateAdded
        isAscending = false
        searchText = ""
    }
    
    func deleteIdea(_ idea: Idea) {
        dataManager.deleteIdea(withId: idea.id)
    }
    
    func toggleFavorite(for idea: Idea) {
        dataManager.toggleFavorite(ideaId: idea.id)
    }
    
    func isFavorite(_ idea: Idea) -> Bool {
        return dataManager.isFavorite(ideaId: idea.id)
    }
    
    func hasActiveFilters() -> Bool {
        return !selectedCategories.isEmpty || 
               sourceFilter != .all || 
               sortOption != .dateAdded || 
               isAscending || 
               !searchText.isEmpty
    }
}
