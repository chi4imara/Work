import Foundation

struct Tournament: Identifiable, Codable {
    let id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var teams: [String]
    var matches: [TournamentMatch]
    var status: TournamentStatus
    var description: String?
    var prize: String?
    
    var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate && status == .active
    }
    
    var isUpcoming: Bool {
        return Date() < startDate && status == .upcoming
    }
    
    var isCompleted: Bool {
        return status == .completed || Date() > endDate
    }
    
    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: startDate)
    }
    
    var formattedEndDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: endDate)
    }
    
    var dateRange: String {
        return "\(formattedStartDate) - \(formattedEndDate)"
    }
    
    var teamsCount: Int {
        return teams.count
    }
    
    var matchesCount: Int {
        return matches.count
    }
    
    var completedMatchesCount: Int {
        return matches.filter { $0.isCompleted }.count
    }
    
    var progress: Double {
        guard matchesCount > 0 else { return 0.0 }
        return Double(completedMatchesCount) / Double(matchesCount)
    }
    
    mutating func addTeam(_ team: String) {
        if !teams.contains(team) {
            teams.append(team)
        }
    }
    
    mutating func removeTeam(_ team: String) {
        teams.removeAll { $0 == team }
    }
    
    mutating func addMatch(_ match: TournamentMatch) {
        matches.append(match)
    }
    
    mutating func updateStatus(_ newStatus: TournamentStatus) {
        status = newStatus
    }
}

struct TournamentMatch: Identifiable, Codable {
    let id = UUID()
    var teamA: String
    var teamB: String
    var scoreA: Int?
    var scoreB: Int?
    var date: Date
    var round: String?
    var isCompleted: Bool
    
    var displayScore: String {
        guard let scoreA = scoreA, let scoreB = scoreB else {
            return "- : -"
        }
        return "\(scoreA) : \(scoreB)"
    }
    
    var displayTeams: String {
        return "\(teamA) vs \(teamB)"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var winner: String? {
        guard let scoreA = scoreA, let scoreB = scoreB, isCompleted else {
            return nil
        }
        
        if scoreA > scoreB {
            return teamA
        } else if scoreB > scoreA {
            return teamB
        } else {
            return nil 
        }
    }
    
    mutating func setScore(teamAScore: Int, teamBScore: Int) {
        scoreA = teamAScore
        scoreB = teamBScore
        isCompleted = true
    }
}

enum TournamentStatus: String, CaseIterable, Codable {
    case upcoming = "Upcoming"
    case active = "Active"
    case completed = "Completed"
    case cancelled = "Cancelled"
    
    var displayName: String {
        return self.rawValue
    }
    
    var color: String {
        switch self {
        case .upcoming:
            return "blue"
        case .active:
            return "green"
        case .completed:
            return "gray"
        case .cancelled:
            return "red"
        }
    }
}
