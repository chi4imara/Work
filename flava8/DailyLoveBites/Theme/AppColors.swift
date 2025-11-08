import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    static let accentPink = Color(red: 0.9, green: 0.5, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.primaryBlue.opacity(0.8),
            Color.primaryPurple.opacity(0.6),
            Color.primaryBlue.opacity(0.9)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.95)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let darkText = Color.black
    static let lightGray = Color.gray.opacity(0.6)
    static let darkGray = Color.gray.opacity(0.8)
    static let secondaryGray = Color.gray
    
    static let successGreen = Color.green
    static let warningYellow = Color.yellow
    static let errorRed = Color.red
    
    static let buttonPrimary = Color.primaryPurple
    static let buttonSecondary = Color.primaryBlue
    static let buttonDisabled = Color.gray.opacity(0.3)
    
    static let difficultyEasy = Color.green
    static let difficultyMedium = Color.orange
    static let difficultyHard = Color.red
}

extension LinearGradient {
    static let backgroundMain = LinearGradient(
        colors: [
            Color.primaryBlue.opacity(0.8),
            Color.primaryPurple.opacity(0.6),
            Color.primaryBlue.opacity(0.9)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.95),
            Color.white.opacity(0.85)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let buttonGradient = LinearGradient(
        colors: [
            Color.primaryPurple,
            Color.primaryBlue
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}
