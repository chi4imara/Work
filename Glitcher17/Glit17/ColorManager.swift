import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    static let primaryPurple = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let secondaryPurple = Color(red: 1.0, green: 0.5, blue: 0.7)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let textWhite = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let cardBackground = Color.white.opacity(0.1)
    static let buttonBackground = Color.white.opacity(0.2)
    static let errorRed = Color.red
    static let successGreen = Color.green
    
    static let mainGradient = LinearGradient(
        colors: [primaryPurple, secondaryPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.15), Color.white.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [accentYellow, accentYellow.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
