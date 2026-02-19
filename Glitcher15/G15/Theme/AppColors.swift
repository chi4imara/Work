import SwiftUI

struct AppColors {
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let mediumBlue = Color(red: 0.3, green: 0.6, blue: 0.95)
    static let deepBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    static let cyanBlue = Color(red: 0.35, green: 0.75, blue: 0.95)
    
    static let yellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let brightYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let goldenYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let pink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let purple = Color(red: 0.7, green: 0.4, blue: 0.9)
    static let mint = Color(red: 0.3, green: 0.9, blue: 0.7)
    static let coral = Color(red: 1.0, green: 0.5, blue: 0.4)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.9)
    static let accentText = Color.white
    
    static let primaryBackground = lightBlue
    static let cardBackground = Color.white.opacity(0.15)
    static let overlayBackground = Color.black.opacity(0.2)
    
    static let success = Color(red: 0.2, green: 0.9, blue: 0.5)
    static let warning = yellow
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let primaryGradient = LinearGradient(
        colors: [
            cyanBlue,
            lightBlue,
            mediumBlue,
            deepBlue,
            Color(red: 0.25, green: 0.55, blue: 0.85)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.2),
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [brightYellow, goldenYellow, yellow],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let yellowGradient = LinearGradient(
        colors: [brightYellow, yellow, goldenYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueYellowGradient = LinearGradient(
        colors: [lightBlue, cyanBlue, brightYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
