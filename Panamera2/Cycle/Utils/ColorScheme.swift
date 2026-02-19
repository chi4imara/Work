import SwiftUI

struct AppColors {
    static let primaryPink = Color(red: 0.95, green: 0.7, blue: 0.8)
    static let secondaryPink = Color(red: 0.9, green: 0.6, blue: 0.75)
    static let accentYellow = Color(red: 1.0, green: 0.85, blue: 0.4)
    static let primaryWhite = Color.white
    
    static let softGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    static let deleteRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryPink, secondaryPink, lightBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    
    static let buttonBackground = accentYellow
    static let buttonText = darkGray
    
    static let primaryText = primaryWhite
    static let secondaryText = darkGray
    static let accentText = accentYellow
}
