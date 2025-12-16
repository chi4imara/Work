import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.7)
    
    static let yellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let lightYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let darkYellow = Color(red: 0.8, green: 0.6, blue: 0.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color.black
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBlue, lightBlue, darkBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBackgroundPressed = Color.white.opacity(0.25)
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    static let floatingElement = Color.white.opacity(0.3)
    static let floatingElementBright = Color.white.opacity(0.6)
}

extension AppColors {
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBlue, lightBlue]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [yellow, lightYellow]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [cardBackground, cardBackground.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
