import SwiftUI

struct ColorManager {
    static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let buttonBackground = Color.white.opacity(0.15)
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.12, blue: 0.25),
            Color(red: 0.12, green: 0.18, blue: 0.35),
            Color(red: 0.15, green: 0.22, blue: 0.4)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.15),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
