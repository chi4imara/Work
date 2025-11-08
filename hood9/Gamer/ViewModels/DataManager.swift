import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var games: [Game] = []
    @Published var sessions: [GameSession] = []
    @Published var players: [Player] = []
    
    private let gamesKey = "saved_games"
    private let sessionsKey = "saved_sessions"
    private let playersKey = "saved_players"
    
    init() {
        loadData()
    }
    
    func addGame(_ game: Game) {
        games.append(game)
        saveGames()
    }
    
    func updateGame(_ game: Game) {
        if let index = games.firstIndex(where: { $0.id == game.id }) {
            games[index] = game
            saveGames()
        }
    }
    
    func deleteGame(_ game: Game) {
        games.removeAll { $0.id == game.id }
        sessions.removeAll { $0.gameId == game.id }
        saveGames()
        saveSessions()
    }
    
    func addSession(_ session: GameSession) {
        sessions.append(session)
        saveSessions()
    }
    
    func updateSession(_ session: GameSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
            saveSessions()
        }
    }
    
    func deleteSession(_ session: GameSession) {
        sessions.removeAll { $0.id == session.id }
        saveSessions()
    }
    
    func addPlayer(_ player: Player) {
        players.append(player)
        savePlayers()
    }
    
    func updatePlayer(oldName: String, newName: String) {
        if let index = players.firstIndex(where: { $0.name == oldName }) {
            players[index].name = newName
            savePlayers()
            
            for i in 0..<sessions.count {
                if sessions[i].players.contains(oldName) {
                    sessions[i].players = sessions[i].players.map { $0 == oldName ? newName : $0 }
                }
                if sessions[i].winner == oldName {
                    sessions[i].winner = newName
                }
            }
            saveSessions()
        }
    }
    
    func deletePlayer(_ player: Player) {
        let hasGames = sessions.contains { $0.players.contains(player.name) }
        if !hasGames {
            players.removeAll { $0.id == player.id }
            savePlayers()
        }
    }
    
    func getSessionsForGame(_ gameId: UUID) -> [GameSession] {
        return sessions.filter { $0.gameId == gameId }
    }
    
    func getLastSessionDate(for gameId: UUID) -> Date? {
        return sessions
            .filter { $0.gameId == gameId }
            .map { $0.date }
            .max()
    }
    
    func getAverageDuration(for gameId: UUID) -> Int? {
        let gameSessions = sessions.filter { $0.gameId == gameId }
        let durations = gameSessions.compactMap { $0.duration }
        guard !durations.isEmpty else { return nil }
        return durations.reduce(0, +) / durations.count
    }
    
    func getTopPlayer(for gameId: UUID) -> (name: String, wins: Int)? {
        let gameSessions = sessions.filter { $0.gameId == gameId }
        guard !gameSessions.isEmpty else { return nil }
        
        var winCounts: [String: Int] = [:]
        for session in gameSessions where session.winner != "Draw" {
            winCounts[session.winner, default: 0] += 1
        }
        
        guard let topPlayer = winCounts.max(by: { $0.value < $1.value }) else { return nil }
        return (topPlayer.key, topPlayer.value)
    }
    
    private func saveGames() {
        if let encoded = try? JSONEncoder().encode(games) {
            UserDefaults.standard.set(encoded, forKey: gamesKey)
        }
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    private func savePlayers() {
        if let encoded = try? JSONEncoder().encode(players) {
            UserDefaults.standard.set(encoded, forKey: playersKey)
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: gamesKey),
           let decoded = try? JSONDecoder().decode([Game].self, from: data) {
            games = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([GameSession].self, from: data) {
            sessions = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: playersKey),
           let decoded = try? JSONDecoder().decode([Player].self, from: data) {
            players = decoded
        }
    }
}

