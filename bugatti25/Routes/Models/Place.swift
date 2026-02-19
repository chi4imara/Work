import Foundation
import SwiftUI

enum PlaceCategory: String, CaseIterable, Identifiable, Codable {
    case cafe = "Cafe"
    case park = "Park"
    case museum = "Museum"
    case attraction = "Attraction"
    case walk = "Walk"
    case photoTask = "Photo Task"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .cafe: return "cup.and.saucer"
        case .park: return "tree"
        case .museum: return "building.columns"
        case .attraction: return "star"
        case .walk: return "figure.walk"
        case .photoTask: return "camera"
        }
    }
}

enum PlaceStatus: String, CaseIterable, Codable {
    case wantToVisit = "Want to Visit"
    case done = "Done"
}

struct Place: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: PlaceCategory
    var imageName: String?
    var status: PlaceStatus
    var isCompleted: Bool
    var completionDate: Date?
    var note: String?
    var whyImportant: String?
    
    init(name: String, category: PlaceCategory, imageName: String? = nil, status: PlaceStatus = .wantToVisit, note: String? = nil, whyImportant: String? = nil) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.imageName = imageName
        self.status = status
        self.isCompleted = false
        self.note = note
        self.whyImportant = whyImportant
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(PlaceCategory.self, forKey: .category)
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
        status = try container.decode(PlaceStatus.self, forKey: .status)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        completionDate = try container.decodeIfPresent(Date.self, forKey: .completionDate)
        note = try container.decodeIfPresent(String.self, forKey: .note)
        whyImportant = try container.decodeIfPresent(String.self, forKey: .whyImportant)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encodeIfPresent(imageName, forKey: .imageName)
        try container.encode(status, forKey: .status)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(completionDate, forKey: .completionDate)
        try container.encodeIfPresent(note, forKey: .note)
        try container.encodeIfPresent(whyImportant, forKey: .whyImportant)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, category, imageName, status, isCompleted, completionDate, note, whyImportant
    }
}
