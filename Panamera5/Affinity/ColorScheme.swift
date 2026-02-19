import SwiftUI

struct AppColors {
    static let primaryPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let primaryWhite = Color.white
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let accentBlue = Color(red: 0.3, green: 0.6, blue: 1.0)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let softGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            primaryPink,
            Color(red: 0.9, green: 0.3, blue: 0.6),
            Color(red: 0.8, green: 0.2, blue: 0.5)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            primaryWhite.opacity(0.9),
            primaryWhite.opacity(0.7)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryText = primaryWhite
    static let secondaryText = primaryWhite.opacity(0.8)
    static let accentText = primaryYellow
    
    static let buttonBackground = primaryYellow
    static let buttonText = darkGray
    static let destructiveButton = Color.red
}
