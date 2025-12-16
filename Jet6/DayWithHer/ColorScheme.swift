import SwiftUI

struct AppColors {
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let secondaryPurple = Color(red: 0.7, green: 0.5, blue: 0.9)
    static let lightPurple = Color(red: 0.85, green: 0.75, blue: 0.95)
    
    static let blueText = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let yellowAccent = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let lightYellow = Color(red: 1.0, green: 0.9, blue: 0.6)
    
    static let backgroundWhite = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.98, blue: 1.0)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    
    static let softPink = Color(red: 1.0, green: 0.85, blue: 0.9)
    static let mintGreen = Color(red: 0.7, green: 0.95, blue: 0.8)
    static let lavender = Color(red: 0.9, green: 0.85, blue: 1.0)
    
    static let primaryText = Color.black
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.5)
    static let lightText = Color(red: 0.6, green: 0.6, blue: 0.7)
    
    static let purpleGradient = LinearGradient(
        colors: [primaryPurple, secondaryPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightPurple, cardBackground],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [cardBackground, backgroundWhite],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
