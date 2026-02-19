import Foundation

enum DrinkType: String, CaseIterable, Codable {
    case whiskey = "Whiskey"
    case rum = "Rum"
    case cognac = "Cognac"
    case vodka = "Vodka"
    case gin = "Gin"
    case tequila = "Tequila"
    case brandy = "Brandy"
    case liqueur = "Liqueur"
    case wine = "Wine"
    case champagne = "Champagne"
    case beer = "Beer"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Drink: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var type: DrinkType
    var strength: Double
    var country: String
    var notes: String
    var dateAdded: Date
    
    init(name: String, type: DrinkType, strength: Double, country: String, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.type = type
        self.strength = strength
        self.country = country
        self.notes = notes
        self.dateAdded = Date()
    }
}

extension Drink {
    static let sampleDrinks: [Drink] = [
        Drink(name: "Macallan 18", type: .whiskey, strength: 43.0, country: "Scotland", notes: "Rich and complex with notes of dried fruits and spice"),
        Drink(name: "Hennessy XO", type: .cognac, strength: 40.0, country: "France", notes: "Smooth and elegant with hints of vanilla and oak"),
        Drink(name: "Grey Goose", type: .vodka, strength: 40.0, country: "France", notes: "Clean and crisp with a smooth finish")
    ]
}
