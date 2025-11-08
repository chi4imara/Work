import Foundation

struct PartyTheme: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var description: String
    var dateCreated: Date
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.dateCreated = Date()
    }
}

extension PartyTheme {
    static let defaultThemes = [
        PartyTheme(title: "Hawaiian Night", description: "Flower necklaces, cocktails, and tropical music"),
        PartyTheme(title: "Hollywood Premiere", description: "Red carpet outfits, photo zone, and movie soundtracks"),
        PartyTheme(title: "Masquerade Ball", description: "Mysterious masks and elegant costumes"),
        PartyTheme(title: "Retro 80s", description: "Disco balls, neon lights, and vintage cassettes"),
        PartyTheme(title: "Cowboy Party", description: "Jeans, hats, and country music"),
        PartyTheme(title: "Casino Night", description: "Cards, chips, and elegant attire"),
        PartyTheme(title: "Beach Party", description: "Sand, sun, and summer vibes"),
        PartyTheme(title: "Winter Wonderland", description: "Snow decorations and cozy atmosphere"),
        PartyTheme(title: "Neon Glow", description: "Blacklight and fluorescent colors"),
        PartyTheme(title: "Vintage Gatsby", description: "1920s style with jazz and glamour"),
        PartyTheme(title: "Superhero Theme", description: "Capes, masks, and comic book fun"),
        PartyTheme(title: "Tropical Paradise", description: "Palm trees, exotic fruits, and island music")
    ]
}
