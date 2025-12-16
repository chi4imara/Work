import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var searchText = ""
    @Published var selectedCategories: Set<String> = []
    @Published var sortOption: SortOption = .alphabetical
    @Published var showingAddGame = false
    @Published var showingCategoryFilter = false
    
    enum SortOption: String, CaseIterable {
        case alphabetical = "Alphabetical A-Z"
        case popularity = "By Popularity"
    }
    
    var filteredGames: [Game] {
        var result = games
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if !selectedCategories.isEmpty {
            result = result.filter { selectedCategories.contains($0.category) }
        }
        
        switch sortOption {
        case .alphabetical:
            result = result.sorted { $0.name < $1.name }
        case .popularity:
            result = result.sorted { $0.favoriteCount > $1.favoriteCount }
        }
        
        return result
    }
    
    var favoriteGames: [Game] {
        games.filter { $0.isFavorite }.sorted { $0.name < $1.name }
    }
    
    init() {
        loadSampleData()
    }
    
    func addGame(_ game: Game) {
        games.append(game)
        updateCategoryCount(for: game.category, increment: true)
    }
    
    func updateGame(_ updatedGame: Game) {
        if let index = games.firstIndex(where: { $0.id == updatedGame.id }) {
            let oldCategory = games[index].category
            games[index] = updatedGame
            
            if oldCategory != updatedGame.category {
                updateCategoryCount(for: oldCategory, increment: false)
                updateCategoryCount(for: updatedGame.category, increment: true)
            }
        }
    }
    
    func deleteGame(_ game: Game) {
        games.removeAll { $0.id == game.id }
        updateCategoryCount(for: game.category, increment: false)
    }
    
    func toggleFavorite(for gameId: UUID) {
        if let index = games.firstIndex(where: { $0.id == gameId }) {
            games[index].toggleFavorite()
        }
    }
    
    func addCategory(_ categoryName: String) {
        let newCategory = Category(name: categoryName)
        categories.append(newCategory)
    }
    
    func deleteCategory(_ category: Category) {
        games.removeAll { $0.category == category.name }
        
        selectedCategories.remove(category.name)
        
        categories.removeAll { $0.id == category.id }
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategories.removeAll()
    }
    
    private func updateCategoryCount(for categoryName: String, increment: Bool) {
        if let index = categories.firstIndex(where: { $0.name == categoryName }) {
            if increment {
                categories[index].gameCount += 1
            } else {
                categories[index].gameCount = max(0, categories[index].gameCount - 1)
            }
        }
    }
    
    private func loadSampleData() {
        
        for category in categories.indices {
            categories[category].gameCount = games.filter { $0.category == categories[category].name }.count
        }
    }
}
