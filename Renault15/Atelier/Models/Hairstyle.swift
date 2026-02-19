import Foundation
import SwiftUI

struct Hairstyle: Identifiable, Codable {
    var id: UUID
    var name: String
    var category: HairstyleCategory
    var hairLength: HairLength
    var hairColor: String
    var photo: Data?
    var comment: String
    var dateCreated: Date
    
    init(id: UUID = UUID(), name: String, category: HairstyleCategory, hairLength: HairLength, hairColor: String, photo: Data? = nil, comment: String = "", dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.hairLength = hairLength
        self.hairColor = hairColor
        self.photo = photo
        self.comment = comment
        self.dateCreated = dateCreated
    }
}

enum HairstyleCategory: String, CaseIterable, Codable {
    case cuts = "Cuts"
    case styling = "Styling"
    case color = "Color"
    case braids = "Braids"
    
    var displayName: String {
        return self.rawValue
    }
}

enum HairLength: String, CaseIterable, Codable {
    case short = "Short"
    case medium = "Medium"
    case long = "Long"
    
    var displayName: String {
        return self.rawValue
    }
}