import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let accentBlue = Color(red: 0.1, green: 0.3, blue: 0.7)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.99)
    
    static let textPrimary = Color.black
    static let textSecondary = Color.gray
    static let textBlue = Color.primaryBlue
    
    static let cardBackground = Color.white
    static let shadowColor = Color.black.opacity(0.1)
    static let borderColor = Color.gray.opacity(0.3)
    
    static let tagColors: [Color] = [
        Color(red: 0.2, green: 0.4, blue: 0.8),
        Color(red: 0.8, green: 0.2, blue: 0.4),
        Color(red: 0.4, green: 0.8, blue: 0.2),
        Color(red: 0.8, green: 0.6, blue: 0.2),
        Color(red: 0.6, green: 0.2, blue: 0.8),
        Color(red: 0.2, green: 0.8, blue: 0.6)
    ]
    
    static func tagColor(for tag: String) -> Color {
        let index = abs(tag.hashValue) % tagColors.count
        return tagColors[index]
    }
}
