import Foundation

struct Game: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var minPlayers: Int
    var maxPlayers: Int
    var minTime: Int
    var maxTime: Int
    var tags: [String]
    var notes: String
    var isActive: Bool
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, minPlayers: Int, maxPlayers: Int, minTime: Int, maxTime: Int, tags: [String] = [], notes: String = "", isActive: Bool = true, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.minPlayers = minPlayers
        self.maxPlayers = maxPlayers
        self.minTime = minTime
        self.maxTime = maxTime
        self.tags = tags
        self.notes = notes
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

