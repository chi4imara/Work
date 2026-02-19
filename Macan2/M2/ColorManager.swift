import SwiftUI

struct ColorManager {
    static let primaryBackground = Color.white
    static let primaryText = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let purpleLight = Color(red: 0.8, green: 0.6, blue: 1.0)
    static let purpleDark = Color(red: 0.5, green: 0.3, blue: 0.8)
    
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let cardBackground = Color(red: 0.98, green: 0.98, blue: 1.0)
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    static let neutralGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBackground, purpleLight.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let purpleGradient = LinearGradient(
        colors: [purpleLight, purpleDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [cardBackground, primaryBackground],
        startPoint: .top,
        endPoint: .bottom
    )
}

