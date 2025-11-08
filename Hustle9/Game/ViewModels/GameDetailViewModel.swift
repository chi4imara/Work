import Foundation
import SwiftUI

class GameDetailViewModel: ObservableObject {
    @Published var game: Game {
        didSet {
            sections = game.sections
        }
    }
    @Published var sections: [GameSection] = []
    
    let gamesViewModel: GamesViewModel
    
    init(game: Game, gamesViewModel: GamesViewModel) {
        self.game = game
        self.gamesViewModel = gamesViewModel
        self.sections = game.sections
    }
    
    func syncWithGamesViewModel() {
        if let updatedGame = gamesViewModel.games.first(where: { $0.id == game.id }) {
            game = updatedGame
        }
    }
    
    func addSection(_ section: GameSection) {
        game.addSection(section)
        sections = game.sections
        gamesViewModel.updateGame(game)
        syncWithGamesViewModel()
    }
    
    func updateSection(at index: Int, with section: GameSection) {
        game.updateSection(at: index, with: section)
        sections = game.sections
        gamesViewModel.updateGame(game)
        syncWithGamesViewModel()
    }
    
    func deleteSection(at index: Int) {
        game.removeSection(at: index)
        sections = game.sections
        gamesViewModel.updateGame(game)
        syncWithGamesViewModel()
    }
    
    func deleteSection(withId id: UUID) {
        if let index = sections.firstIndex(where: { $0.id == id }) {
            deleteSection(at: index)
        }
    }
    
    func toggleFavorite() {
        game.toggleFavorite()
        gamesViewModel.updateGame(game)
        syncWithGamesViewModel()
    }
    
    func updateGameInfo(name: String, category: GameCategory, description: String) {
        game.updateInfo(name: name, category: category, description: description)
        gamesViewModel.updateGame(game)
        syncWithGamesViewModel()
    }
    
    func deleteGame() {
        gamesViewModel.deleteGame(game)
    }
}
