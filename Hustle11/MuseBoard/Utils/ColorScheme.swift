import SwiftUI

struct AppColors {
    
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let secondaryBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let accentBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let background = primaryBlue
    static let cardBackground = Color.white.opacity(0.15)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let elementBackground = Color.white.opacity(0.2)
    static let elementBorder = Color.white.opacity(0.3)
    static let buttonBackground = Color.white.opacity(0.25)
    static let buttonPressed = Color.white.opacity(0.4)
    
    static let workColor = Color.orange
    static let hobbyColor = Color.purple
    static let travelColor = Color.green
    static let familyColor = Color.pink
    static let otherColor = Color.gray
    
    static let tagColors: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow, .green, .mint, .teal, .cyan
    ]
    
    static let wheelColors: [Color] = [
        Color(red: 0.2, green: 0.6, blue: 1.0),
        Color(red: 0.2, green: 0.8, blue: 0.4),
        Color(red: 1.0, green: 0.6, blue: 0.2),
        Color(red: 0.8, green: 0.4, blue: 1.0),
        Color(red: 1.0, green: 0.4, blue: 0.6),
        Color(red: 1.0, green: 0.3, blue: 0.3),    
        Color(red: 0.2, green: 0.8, blue: 0.8),
        Color(red: 0.4, green: 0.9, blue: 0.7),
        Color(red: 0.5, green: 0.4, blue: 1.0),
        Color(red: 0.8, green: 0.6, blue: 0.4)
    ]
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let backgroundGradient = LinearGradient(
        colors: [
            primaryBlue,
            secondaryBlue.opacity(0.8),
            primaryBlue.opacity(0.9)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.2),
            Color.white.opacity(0.1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.3),
            Color.white.opacity(0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static func categoryColor(for category: Category) -> Color {
        switch category {
        case .work:
            return workColor
        case .hobby:
            return hobbyColor
        case .travel:
            return travelColor
        case .family:
            return familyColor
        case .other:
            return otherColor
        }
    }
    
    static func randomTagColor() -> Color {
        return tagColors.randomElement() ?? .blue
    }
}
