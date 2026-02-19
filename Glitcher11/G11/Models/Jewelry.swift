import Foundation

struct Jewelry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var style: String
    var type: JewelryType
    var note: String
    var isFavorite: Bool
    var dateCreated: Date
    
    init(name: String, style: String, type: JewelryType, note: String = "") {
        self.id = UUID()
        self.name = name
        self.style = style
        self.type = type
        self.note = note
        self.isFavorite = false
        self.dateCreated = Date()
    }
}

enum JewelryStyle: String, CaseIterable, Codable {
    case minimalism = "Minimalism"
    case classic = "Classic"
    case boho = "Boho"
    case romantic = "Romantic"
    case modern = "Modern"
    case custom = "Custom"
    
    var displayName: String {
        return rawValue
    }
}

enum JewelryType: String, CaseIterable, Codable {
    case earrings = "Earrings"
    case ring = "Ring"
    case bracelet = "Bracelet"
    case necklace = "Necklace"
    case choker = "Choker"
    case brooch = "Brooch"
    case other = "Other"
    
    var displayName: String {
        return rawValue
    }
}

struct CustomStyle: Identifiable, Codable {
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
