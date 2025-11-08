import Foundation

struct Match: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var teamA: String
    var teamB: String
    var scoreA: Int
    var scoreB: Int
    var mvp: String?
    var note: String?
    
    var result: MatchResult {
        if scoreA > scoreB {
            return .win
        } else if scoreA < scoreB {
            return .loss
        } else {
            return .draw
        }
    }
    
    var scoreDifference: Int {
        return scoreA - scoreB
    }
    
    var displayScore: String {
        return "\(scoreA) : \(scoreB)"
    }
    
    var displayTeams: String {
        return "\(teamA) vs \(teamB)"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

enum MatchResult: String, CaseIterable {
    case win = "Win"
    case loss = "Loss"
    case draw = "Draw"
}
