import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favoriteIdeas: [Idea] = []
    @Published var sortOption: FavoriteSortOption = .dateAdded
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadFavorites()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest(
            dataManager.$ideas,
            dataManager.$favorites
        )
        .sink { [weak self] _, _ in
            self?.loadFavorites()
        }
        .store(in: &cancellables)
        
        $sortOption
            .sink { [weak self] _ in
                self?.applySorting()
            }
            .store(in: &cancellables)
    }
    
    func loadFavorites() {
        favoriteIdeas = dataManager.getFavoriteIdeas()
        applySorting()
    }
    
    private func applySorting() {
        switch sortOption {
        case .alphabetical:
            favoriteIdeas.sort { $0.title < $1.title }
        case .dateAdded:
            favoriteIdeas.sort { $0.dateAdded > $1.dateAdded }
        }
    }
    
    func removeFromFavorites(_ idea: Idea) {
        dataManager.toggleFavorite(ideaId: idea.id)
    }
    
    func clearAllFavorites() {
        dataManager.clearAllFavorites()
    }
    
    func setSortOption(_ option: FavoriteSortOption) {
        sortOption = option
    }
    
    var isEmpty: Bool {
        return favoriteIdeas.isEmpty
    }
}

enum FavoriteSortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case dateAdded = "Date Added"
    
    var displayName: String {
        switch self {
        case .alphabetical:
            return "Sort Alphabetically"
        case .dateAdded:
            return "Sort by Date Added"
        }
    }
}
