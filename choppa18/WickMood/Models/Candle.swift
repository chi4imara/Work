import Foundation

enum Mood: String, CaseIterable, Identifiable, Codable {
    case cozy = "Cozy"
    case relaxing = "Relaxing"
    case refreshing = "Refreshing"
    case energetic = "Energetic"
    case romantic = "Romantic"
    
    var id: String { self.rawValue }
}

enum Season: String, CaseIterable, Identifiable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var id: String { self.rawValue }
}

struct Candle: Identifiable, Codable {
    let id: UUID
    var name: String
    var brand: String
    var notes: String
    var mood: Mood
    var season: Season
    var impression: String
    var isFavorite: Bool
    var dateCreated: Date
    
    init(name: String, brand: String, notes: String, mood: Mood, season: Season, impression: String, isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.notes = notes
        self.mood = mood
        self.season = season
        self.impression = impression
        self.isFavorite = isFavorite
        self.dateCreated = Date()
    }
    
    init(id: UUID, name: String, brand: String, notes: String, mood: Mood, season: Season, impression: String, isFavorite: Bool, dateCreated: Date) {
        self.id = id
        self.name = name
        self.brand = brand
        self.notes = notes
        self.mood = mood
        self.season = season
        self.impression = impression
        self.isFavorite = isFavorite
        self.dateCreated = dateCreated
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case brand
        case notes
        case mood
        case season
        case impression
        case isFavorite
        case dateCreated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        brand = try container.decode(String.self, forKey: .brand)
        notes = try container.decode(String.self, forKey: .notes)
        mood = try container.decode(Mood.self, forKey: .mood)
        season = try container.decode(Season.self, forKey: .season)
        impression = try container.decode(String.self, forKey: .impression)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(brand, forKey: .brand)
        try container.encode(notes, forKey: .notes)
        try container.encode(mood, forKey: .mood)
        try container.encode(season, forKey: .season)
        try container.encode(impression, forKey: .impression)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(dateCreated, forKey: .dateCreated)
    }
}
