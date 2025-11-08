import Foundation
import SwiftUI

class GamesViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var filteredGames: [Game] = []
    @Published var searchText: String = ""
    @Published var selectedCategories: Set<GameCategory> = []
    @Published var sortOption: SortOption = .dateAdded
    @Published var isSearching: Bool = false
    
    enum SortOption: String, CaseIterable {
        case alphabetical = "Alphabetical"
        case dateAdded = "Date Added"
        
        var displayName: String {
            return rawValue
        }
    }
    
    init() {
        loadGames()
        updateFilteredGames()
    }
    
    func addGame(_ game: Game) {
        games.append(game)
        saveGames()
        updateFilteredGames()
    }
    
    func updateGame(_ game: Game) {
        if let index = games.firstIndex(where: { $0.id == game.id }) {
            games[index] = game
            saveGames()
            updateFilteredGames()
        }
    }
    
    func deleteGame(_ game: Game) {
        games.removeAll { $0.id == game.id }
        saveGames()
        updateFilteredGames()
    }
    
    func deleteGames(_ gamesToDelete: [Game]) {
        let idsToDelete = Set(gamesToDelete.map { $0.id })
        games.removeAll { idsToDelete.contains($0.id) }
        saveGames()
        updateFilteredGames()
    }
    
    func toggleFavorite(for game: Game) {
        if let index = games.firstIndex(where: { $0.id == game.id }) {
            games[index].toggleFavorite()
            saveGames()
            updateFilteredGames()
        }
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        updateFilteredGames()
    }
    
    func updateSortOption(_ option: SortOption) {
        sortOption = option
        updateFilteredGames()
    }
    
    func updateCategoryFilter(_ categories: Set<GameCategory>) {
        selectedCategories = categories
        updateFilteredGames()
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategories.removeAll()
        sortOption = .dateAdded
        updateFilteredGames()
    }
    
    func gameExists(withName name: String) -> Bool {
        return games.contains { $0.name.lowercased() == name.lowercased() }
    }
    
    func refreshData() {
        updateFilteredGames()
    }
    
    private func updateFilteredGames() {
        var filtered = games
        
        if !searchText.isEmpty {
            filtered = filtered.filter { game in
                game.name.localizedCaseInsensitiveContains(searchText) ||
                game.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !selectedCategories.isEmpty {
            filtered = filtered.filter { selectedCategories.contains($0.category) }
        }
        
        switch sortOption {
        case .alphabetical:
            filtered.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .dateAdded:
            filtered.sort { $0.dateCreated > $1.dateCreated }
        }
        
        filteredGames = filtered
    }
    
    private func saveGames() {
        if let encoded = try? JSONEncoder().encode(games) {
            UserDefaults.standard.set(encoded, forKey: "SavedGames")
        }
    }
    
    private func loadGames() {
        if let data = UserDefaults.standard.data(forKey: "SavedGames"),
           let decoded = try? JSONDecoder().decode([Game].self, from: data) {
            games = decoded
        }
    }
}
