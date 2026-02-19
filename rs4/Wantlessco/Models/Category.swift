import Foundation
import SwiftUI

struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    var color: CategoryColor
    var createdAt: Date
    
    init(name: String, color: CategoryColor = .blue) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.createdAt = Date()
    }
}

enum CategoryColor: String, CaseIterable, Codable {
    case blue = "Blue"
    case purple = "Purple"
    case green = "Green"
    case orange = "Orange"
    case pink = "Pink"
    case red = "Red"
    case yellow = "Yellow"
    case teal = "Teal"
    
    var color: Color {
        switch self {
        case .blue:
            return AppColors.primaryBlue
        case .purple:
            return AppColors.primaryPurple
        case .green:
            return AppColors.wantColor
        case .orange:
            return Color.orange.opacity(0.8)
        case .pink:
            return Color.pink.opacity(0.8)
        case .red:
            return AppColors.dontWantColor
        case .yellow:
            return Color.yellow.opacity(0.8)
        case .teal:
            return Color.teal.opacity(0.8)
        }
    }
}
