import SwiftUI

struct ColorTheme {
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let lightBlue = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let primaryBackground = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.15, blue: 0.35),
            Color(red: 0.1, green: 0.2, blue: 0.4),
            Color(red: 0.15, green: 0.25, blue: 0.45)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 0.15, green: 0.25, blue: 0.45).opacity(0.8)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = lightBlue
    
    static let primaryButton = lightBlue
    static let secondaryButton = orange
    static let destructiveButton = Color.red
    
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    
    static let tabBarBackground = Color(red: 0.08, green: 0.18, blue: 0.38)
    static let tabBarSelected = lightBlue
    static let tabBarUnselected = Color.white.opacity(0.6)
}
