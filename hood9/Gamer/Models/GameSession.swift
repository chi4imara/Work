import Foundation

struct GameSession: Identifiable, Codable, Equatable {
    let id: UUID
    var gameId: UUID
    var date: Date
    var players: [String]
    var winner: String
    var duration: Int? 
    var location: String
    var notes: String
    var createdAt: Date
    
    init(id: UUID = UUID(), gameId: UUID, date: Date, players: [String], winner: String, duration: Int? = nil, location: String = "", notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.gameId = gameId
        self.date = date
        self.players = players
        self.winner = winner
        self.duration = duration
        self.location = location
        self.notes = notes
        self.createdAt = createdAt
    }
}

