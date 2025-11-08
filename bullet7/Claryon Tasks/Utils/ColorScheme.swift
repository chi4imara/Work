import SwiftUI

extension Color {
    static let primaryPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let softGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let lightPurple = Color(red: 0.8, green: 0.7, blue: 0.9)
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryPurple, primaryBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.15)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.7)
    static let completedText = Color.white.opacity(0.5)
}
