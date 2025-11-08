import Foundation
import SwiftUI

class TournamentViewModel: ObservableObject {
    @Published var tournaments: [Tournament] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var statusFilter: TournamentStatusFilter = .all
    @Published var sortOption: TournamentSortOption = .dateNewest
    
    private let userDefaults = UserDefaults.standard
    private let tournamentsKey = "SavedTournaments"
    
    init() {
        loadData()
    }
    
    func loadData() {
        loadTournaments()
    }
    
    private func loadTournaments() {
        if let data = userDefaults.data(forKey: tournamentsKey),
           let decodedTournaments = try? JSONDecoder().decode([Tournament].self, from: data) {
            self.tournaments = decodedTournaments
        }
    }
    
    private func saveTournaments() {
        if let encoded = try? JSONEncoder().encode(tournaments) {
            userDefaults.set(encoded, forKey: tournamentsKey)
        }
    }
    
    func addTournament(_ tournament: Tournament) {
        tournaments.append(tournament)
        saveTournaments()
    }
    
    func updateTournament(_ tournament: Tournament) {
        if let index = tournaments.firstIndex(where: { $0.id == tournament.id }) {
            tournaments[index] = tournament
            saveTournaments()
        }
    }
    
    func deleteTournament(_ tournament: Tournament) {
        print("DEBUG: deleteTournament called for: \(tournament.name) (ID: \(tournament.id))")
        let beforeCount = tournaments.count
        tournaments.removeAll { $0.id == tournament.id }
        let afterCount = tournaments.count
        print("DEBUG: Tournaments count: \(beforeCount) -> \(afterCount)")
        saveTournaments()
    }
    
    func deleteTournaments(_ tournamentsToDelete: [Tournament]) {
        print("DEBUG: TournamentViewModel.deleteTournaments called with \(tournamentsToDelete.count) tournaments")
        print("DEBUG: Current tournaments count before deletion: \(tournaments.count)")
        
        for tournament in tournamentsToDelete {
            print("DEBUG: Deleting tournament: \(tournament.name) (ID: \(tournament.id))")
            deleteTournament(tournament)
        }
        
        print("DEBUG: Current tournaments count after deletion: \(tournaments.count)")
    }
    
    func addTeamToTournament(_ tournamentId: UUID, team: String) {
        if let index = tournaments.firstIndex(where: { $0.id == tournamentId }) {
            tournaments[index].addTeam(team)
            saveTournaments()
        }
    }
    
    func removeTeamFromTournament(_ tournamentId: UUID, team: String) {
        if let index = tournaments.firstIndex(where: { $0.id == tournamentId }) {
            tournaments[index].removeTeam(team)
            saveTournaments()
        }
    }
    
    func addMatchToTournament(_ tournamentId: UUID, match: TournamentMatch) {
        if let index = tournaments.firstIndex(where: { $0.id == tournamentId }) {
            tournaments[index].addMatch(match)
            saveTournaments()
        }
    }
    
    func updateTournamentStatus(_ tournamentId: UUID, status: TournamentStatus) {
        if let index = tournaments.firstIndex(where: { $0.id == tournamentId }) {
            tournaments[index].updateStatus(status)
            saveTournaments()
        }
    }
    
    func updateMatchScore(_ tournamentId: UUID, matchId: UUID, teamAScore: Int, teamBScore: Int) {
        if let tournamentIndex = tournaments.firstIndex(where: { $0.id == tournamentId }),
           let matchIndex = tournaments[tournamentIndex].matches.firstIndex(where: { $0.id == matchId }) {
            tournaments[tournamentIndex].matches[matchIndex].setScore(teamAScore: teamAScore, teamBScore: teamBScore)
            saveTournaments()
        }
    }
    
    var totalTournaments: Int {
        tournaments.count
    }
    
    var activeTournaments: Int {
        tournaments.filter { $0.status == .active }.count
    }
    
    var upcomingTournaments: Int {
        tournaments.filter { $0.status == .upcoming }.count
    }
    
    var completedTournaments: Int {
        tournaments.filter { $0.status == .completed }.count
    }
    
    var totalMatches: Int {
        tournaments.reduce(0) { $0 + $1.matchesCount }
    }
    
    var completedMatches: Int {
        tournaments.reduce(0) { $0 + $1.completedMatchesCount }
    }
    
    var totalTeams: Int {
        let allTeams = Set(tournaments.flatMap { $0.teams })
        return allTeams.count
    }
    
    var filteredAndSortedTournaments: [Tournament] {
        let filtered = filteredTournaments
        return sortedTournaments(filtered)
    }
    
    private var filteredTournaments: [Tournament] {
        switch statusFilter {
        case .all:
            return tournaments
        case .active:
            return tournaments.filter { $0.status == .active }
        case .upcoming:
            return tournaments.filter { $0.status == .upcoming }
        case .completed:
            return tournaments.filter { $0.status == .completed }
        case .cancelled:
            return tournaments.filter { $0.status == .cancelled }
        }
    }
    
    private func sortedTournaments(_ tournaments: [Tournament]) -> [Tournament] {
        switch sortOption {
        case .dateNewest:
            return tournaments.sorted { $0.startDate > $1.startDate }
        case .dateOldest:
            return tournaments.sorted { $0.startDate < $1.startDate }
        case .nameAZ:
            return tournaments.sorted { $0.name < $1.name }
        case .nameZA:
            return tournaments.sorted { $0.name > $1.name }
        case .teamsCount:
            return tournaments.sorted { $0.teamsCount > $1.teamsCount }
        case .progress:
            return tournaments.sorted { $0.progress > $1.progress }
        }
    }
    
    func getTournament(by id: UUID) -> Tournament? {
        return tournaments.first { $0.id == id }
    }
    
    func getUpcomingTournaments() -> [Tournament] {
        return tournaments.filter { $0.isUpcoming }.sorted { $0.startDate < $1.startDate }
    }
    
    func getActiveTournaments() -> [Tournament] {
        return tournaments.filter { $0.isActive }.sorted { $0.startDate < $1.startDate }
    }
    
    func getCompletedTournaments() -> [Tournament] {
        return tournaments.filter { $0.isCompleted }.sorted { $0.endDate > $1.endDate }
    }
    
    func generateBracket(for tournament: Tournament) -> [[TournamentMatch]] {
        let teams = tournament.teams
        var rounds: [[TournamentMatch]] = []
        
        if teams.count >= 2 {
            var currentTeams = teams
            var roundNumber = 1
            
            while currentTeams.count > 1 {
                var roundMatches: [TournamentMatch] = []
                
                for i in stride(from: 0, to: currentTeams.count - 1, by: 2) {
                    let match = TournamentMatch(
                        teamA: currentTeams[i],
                        teamB: currentTeams[i + 1],
                        date: tournament.startDate,
                        round: "Round \(roundNumber)",
                        isCompleted: false
                    )
                    roundMatches.append(match)
                }
                
                rounds.append(roundMatches)
                currentTeams = Array(currentTeams.prefix(currentTeams.count / 2))
                roundNumber += 1
            }
        }
        
        return rounds
    }
}

enum TournamentStatusFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case upcoming = "Upcoming"
    case completed = "Completed"
    case cancelled = "Cancelled"
    
    var displayName: String {
        return self.rawValue
    }
}

enum TournamentSortOption: String, CaseIterable {
    case dateNewest = "Date (Newest)"
    case dateOldest = "Date (Oldest)"
    case nameAZ = "Name (A-Z)"
    case nameZA = "Name (Z-A)"
    case teamsCount = "Teams Count"
    case progress = "Progress"
    
    var displayName: String {
        return self.rawValue
    }
}
