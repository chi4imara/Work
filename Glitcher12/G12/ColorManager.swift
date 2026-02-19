import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    static let primaryBackground = LinearGradient(
        colors: [
            Color(red: 0.5, green: 0.8, blue: 1.0),
            Color(red: 0.3, green: 0.7, blue: 0.95),
            Color(red: 0.2, green: 0.6, blue: 0.9)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let skyBlue = Color(red: 0.4, green: 0.75, blue: 1.0)
    static let lightSkyBlue = Color(red: 0.6, green: 0.85, blue: 1.0)
    static let darkSkyBlue = Color(red: 0.25, green: 0.65, blue: 0.9)
    
    static let yellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.3)
    static let darkYellow = Color(red: 0.9, green: 0.7, blue: 0.0)
    static let goldenYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let white = Color.white
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let mediumGray = Color(red: 0.7, green: 0.7, blue: 0.7)
    static let darkGray = Color(red: 0.4, green: 0.4, blue: 0.4)
    
    static let accentYellow = Color(red: 1.0, green: 0.9, blue: 0.1)
    static let accentCyan = Color(red: 0.2, green: 0.9, blue: 1.0)
    static let accentPink = Color(red: 1.0, green: 0.5, blue: 0.8)
    static let successGreen = Color(red: 0.2, green: 0.9, blue: 0.5)
    static let errorRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let primaryButton = LinearGradient(
        colors: [yellow, goldenYellow],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let secondaryButton = LinearGradient(
        colors: [lightYellow, yellow],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let deleteButton = LinearGradient(
        colors: [errorRed, Color.red],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let ballColor1 = Color.white.opacity(0.15)
    static let ballColor2 = Color.white.opacity(0.1)
    static let ballColor3 = Color(red: 1.0, green: 0.95, blue: 0.8).opacity(0.2)
    static let ballColor4 = Color(red: 0.9, green: 0.95, blue: 1.0).opacity(0.15)
}

extension Color {
    static let theme = ColorManager.self
}
