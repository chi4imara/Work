import Foundation
import SwiftUI

class MatchViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var players: [Player] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var dateFilter: DateFilter = .all
    @Published var sortOption: SortOption = .dateNewest
    
    private let userDefaults = UserDefaults.standard
    private let matchesKey = "SavedMatches"
    private let playersKey = "SavedPlayers"
    
    init() {
        loadData()
    }
    
    func loadData() {
        loadMatches()
        loadPlayers()
    }
    
    private func loadMatches() {
        if let data = userDefaults.data(forKey: matchesKey),
           let decodedMatches = try? JSONDecoder().decode([Match].self, from: data) {
            self.matches = decodedMatches
        }
    }
    
    private func loadPlayers() {
        if let data = userDefaults.data(forKey: playersKey),
           let decodedPlayers = try? JSONDecoder().decode([Player].self, from: data) {
            self.players = decodedPlayers
        }
    }
    
    private func saveMatches() {
        if let encoded = try? JSONEncoder().encode(matches) {
            userDefaults.set(encoded, forKey: matchesKey)
        }
    }
    
    private func savePlayers() {
        if let encoded = try? JSONEncoder().encode(players) {
            userDefaults.set(encoded, forKey: playersKey)
        }
    }
    
    func addMatch(_ match: Match) {
        matches.append(match)
        updatePlayerStats(for: match, isNew: true)
        saveMatches()
        savePlayers()
    }
    
    func updateMatch(_ match: Match, oldMatch: Match) {
        if let index = matches.firstIndex(where: { $0.id == match.id }) {
            matches[index] = match
            updatePlayerStatsForEdit(oldMatch: oldMatch, newMatch: match)
            saveMatches()
            savePlayers()
        }
    }
    
    func deleteMatch(_ match: Match) {
        matches.removeAll { $0.id == match.id }
        updatePlayerStats(for: match, isNew: false)
        saveMatches()
        savePlayers()
    }
    
    func deleteMatches(_ matchesToDelete: [Match]) {
        for match in matchesToDelete {
            deleteMatch(match)
        }
    }
    
    func addPlayer(_ name: String) {
        let player = Player(name: name)
        players.append(player)
        savePlayers()
    }
    
    func updatePlayer(_ player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players[index] = player
            savePlayers()
        }
    }
    
    func deletePlayer(_ player: Player) -> Bool {
        let matchesWithPlayer = matches.filter { $0.mvp == player.name }
        if !matchesWithPlayer.isEmpty {
            return false
        }
        players.removeAll { $0.id == player.id }
        savePlayers()
        return true
    }
    
    func renamePlayer(oldName: String, newName: String) {
        if let playerIndex = players.firstIndex(where: { $0.name == oldName }) {
            players[playerIndex].name = newName
        }
        
        for index in matches.indices {
            if matches[index].mvp == oldName {
                matches[index].mvp = newName
            }
        }
        
        saveMatches()
        savePlayers()
    }
    
    var totalMatches: Int {
        matches.count
    }
    
    var wins: Int {
        matches.filter { $0.result == .win }.count
    }
    
    var losses: Int {
        matches.filter { $0.result == .loss }.count
    }
    
    var draws: Int {
        matches.filter { $0.result == .draw }.count
    }
    
    var mvpFrequency: [(String, Int)] {
        let mvpCounts = Dictionary(grouping: matches.compactMap { $0.mvp }) { $0 }
            .mapValues { $0.count }
        return mvpCounts.sorted { $0.value > $1.value }
    }
    
    var filteredAndSortedMatches: [Match] {
        let filtered = filteredMatches
        return sortedMatches(filtered)
    }
    
    private var filteredMatches: [Match] {
        let calendar = Calendar.current
        let now = Date()
        
        switch dateFilter {
        case .all:
            return matches
        case .today:
            return matches.filter { calendar.isDate($0.date, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return matches.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return matches.filter { $0.date >= monthAgo }
        }
    }
    
    private func sortedMatches(_ matches: [Match]) -> [Match] {
        switch sortOption {
        case .dateNewest:
            return matches.sorted { $0.date > $1.date }
        case .dateOldest:
            return matches.sorted { $0.date < $1.date }
        case .scoreDifference:
            return matches.sorted { abs($0.scoreDifference) > abs($1.scoreDifference) }
        case .mvpAlphabetical:
            return matches.sorted { ($0.mvp ?? "") < ($1.mvp ?? "") }
        }
    }
    
    private func updatePlayerStats(for match: Match, isNew: Bool) {
        guard let mvpName = match.mvp else { return }
        
        if let playerIndex = players.firstIndex(where: { $0.name == mvpName }) {
            if isNew {
                players[playerIndex].incrementMVP(matchDate: match.date)
            } else {
                players[playerIndex].decrementMVP()
            }
        } else if isNew {
            var newPlayer = Player(name: mvpName)
            newPlayer.incrementMVP(matchDate: match.date)
            players.append(newPlayer)
        }
    }
    
    private func updatePlayerStatsForEdit(oldMatch: Match, newMatch: Match) {
        if let oldMVP = oldMatch.mvp,
           let playerIndex = players.firstIndex(where: { $0.name == oldMVP }) {
            players[playerIndex].decrementMVP()
        }
        
        if let newMVP = newMatch.mvp {
            if let playerIndex = players.firstIndex(where: { $0.name == newMVP }) {
                players[playerIndex].incrementMVP(matchDate: newMatch.date)
            } else {
                var newPlayer = Player(name: newMVP)
                newPlayer.incrementMVP(matchDate: newMatch.date)
                players.append(newPlayer)
            }
        }
    }
    
    func getPlayerSuggestions(for text: String) -> [String] {
        if text.isEmpty {
            return players.map { $0.name }
        }
        return players.filter { $0.name.lowercased().contains(text.lowercased()) }.map { $0.name }
    }
}

enum DateFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case week = "Week"
    case month = "Month"
}

enum SortOption: String, CaseIterable {
    case dateNewest = "Date (Newest)"
    case dateOldest = "Date (Oldest)"
    case scoreDifference = "Score Difference"
    case mvpAlphabetical = "MVP (A-Z)"
}
