import SwiftUI

struct AppColors {
    static let primaryPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let primaryWhite = Color.white
    static let primaryYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    
    static let secondaryPurple = Color(red: 0.7, green: 0.3, blue: 0.9)
    static let secondaryBlue = Color(red: 0.3, green: 0.7, blue: 1.0)
    static let secondaryGreen = Color(red: 0.4, green: 0.8, blue: 0.6)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    
    static let textPrimary = primaryWhite
    static let textSecondary = Color.white.opacity(0.8)
    static let textAccent = primaryYellow
    
    static let backgroundGradient = LinearGradient(
        colors: [
            primaryPink,
            secondaryPurple,
            secondaryBlue
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            primaryPink.opacity(0.3),
            secondaryPurple.opacity(0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let splashGradient = RadialGradient(
        colors: [
            primaryYellow,
            primaryPink,
            secondaryPurple
        ],
        center: .center,
        startRadius: 50,
        endRadius: 300
    )
    
    static let buttonPrimary = primaryYellow
    static let buttonSecondary = primaryWhite.opacity(0.2)
    static let buttonDanger = Color.red
    
    static let separatorColor = primaryWhite.opacity(0.3)
    static let shadowColor = Color.black.opacity(0.2)
}
