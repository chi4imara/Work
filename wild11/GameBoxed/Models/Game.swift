import Foundation

struct Game: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: String
    var playerCount: String
    var description: String
    var isFavorite: Bool = false
    var favoriteCount: Int = 0
    let dateAdded: Date
    
    init(name: String, category: String, playerCount: String, description: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.playerCount = playerCount
        self.description = description
        self.dateAdded = Date()
    }
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            favoriteCount += 1
        }
    }
}
