import Foundation

struct MovieCollection: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var movieIds: [UUID]
    var isCustom: Bool
    var createdAt: Date
    var color: CollectionColor
    
    enum CollectionColor: String, CaseIterable, Codable {
        case blue = "blue"
        case green = "green"
        case orange = "orange"
        case purple = "purple"
        case red = "red"
        case pink = "pink"
        
        var displayName: String {
            switch self {
            case .blue: return "Blue"
            case .green: return "Green"
            case .orange: return "Orange"
            case .purple: return "Purple"
            case .red: return "Red"
            case .pink: return "Pink"
            }
        }
        
        var colorValue: Color {
            switch self {
            case .blue: return AppColors.primaryBlue
            case .green: return AppColors.accent
            case .orange: return AppColors.warning
            case .purple: return Color.purple
            case .red: return AppColors.error
            case .pink: return Color.pink
            }
        }
    }
    
    init(name: String, description: String, movieIds: [UUID] = [], isCustom: Bool = true, color: CollectionColor = .blue) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.movieIds = movieIds
        self.isCustom = isCustom
        self.createdAt = Date()
        self.color = color
    }
    
    static let predefinedCollections = [
        MovieCollection(
            name: "Classic Cinema",
            description: "Timeless masterpieces of cinema",
            isCustom: false,
            color: .purple
        ),
        MovieCollection(
            name: "Modern Blockbusters",
            description: "Recent big-budget productions",
            isCustom: false,
            color: .orange
        ),
        MovieCollection(
            name: "Hidden Gems",
            description: "Underrated films worth watching",
            isCustom: false,
            color: .green
        ),
        MovieCollection(
            name: "Sci-Fi Collection",
            description: "Science fiction and futuristic films",
            isCustom: false,
            color: .blue
        ),
        MovieCollection(
            name: "Romance & Drama",
            description: "Emotional and heartfelt stories",
            isCustom: false,
            color: .pink
        )
    ]
}

import SwiftUI
