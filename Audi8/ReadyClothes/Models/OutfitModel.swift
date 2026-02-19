import Foundation
import SwiftUI

enum OutfitCategory: String, CaseIterable, Codable {
    case casual = "Casual"
    case outing = "Outing"
    case travel = "Travel"
    
    var displayName: String {
        switch self {
        case .casual:
            return "Casual"
        case .outing:
            return "Outing"
        case .travel:
            return "Travel"
        }
    }
}

struct Outfit: Identifiable, Codable {
    let id = UUID()
    var name: String
    var description: String
    var category: OutfitCategory
    var isFavorite: Bool
    var imageData: Data?
    var createdAt: Date
    
    init(name: String, description: String = "", category: OutfitCategory, isFavorite: Bool = false, imageData: Data? = nil) {
        self.name = name
        self.description = description
        self.category = category
        self.isFavorite = isFavorite
        self.imageData = imageData
        self.createdAt = Date()
    }
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
}