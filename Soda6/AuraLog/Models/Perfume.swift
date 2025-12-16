import Foundation

struct Perfume: Identifiable, Codable {
    let id = UUID()
    var name: String
    var brand: String
    var notes: String
    var season: Season
    var mood: Mood
    var favoriteCombinations: String
    var usageCount: Int = 0
    var dateAdded: Date = Date()
    
    enum Season: String, CaseIterable, Codable {
        case spring = "Spring"
        case summer = "Summer"
        case autumn = "Autumn"
        case winter = "Winter"
        case universal = "Universal"
    }
    
    enum Mood: String, CaseIterable, Codable {
        case energetic = "Energetic"
        case romantic = "Romantic"
        case casual = "Casual"
        case evening = "Evening"
        case fresh = "Fresh"
        case mysterious = "Mysterious"
    }
}
