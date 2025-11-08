import Foundation

struct Player: Identifiable, Codable {
    let id = UUID()
    var name: String
    var matchesPlayed: Int = 0
    var mvpCount: Int = 0
    var lastMatchDate: Date?
    
    var formattedLastMatchDate: String {
        guard let lastMatchDate = lastMatchDate else {
            return "No matches"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: lastMatchDate)
    }
    
    mutating func incrementMVP(matchDate: Date) {
        mvpCount += 1
        matchesPlayed += 1
        lastMatchDate = matchDate
    }
    
    mutating func decrementMVP() {
        if mvpCount > 0 {
            mvpCount -= 1
        }
        if matchesPlayed > 0 {
            matchesPlayed -= 1
        }
    }
}
