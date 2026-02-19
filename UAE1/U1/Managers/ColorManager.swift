import SwiftUI

struct ColorManager {
    static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3) 
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    static let tertiaryBackground = Color(red: 0.2, green: 0.25, blue: 0.4)
    
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.8, green: 0.85, blue: 0.9)
    static let tertiaryText = Color(red: 0.6, green: 0.7, blue: 0.8)
    
    static let accent = Color(red: 0.3, green: 0.7, blue: 1.0)
    static let accentSecondary = Color(red: 0.2, green: 0.6, blue: 0.9)
    
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.7, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let cardBackground = Color(red: 0.12, green: 0.17, blue: 0.32)
    static let surfaceBackground = Color(red: 0.08, green: 0.12, blue: 0.25)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.1, blue: 0.2),
            Color(red: 0.1, green: 0.15, blue: 0.3),
            Color(red: 0.15, green: 0.2, blue: 0.35)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.12, green: 0.17, blue: 0.32),
            Color(red: 0.15, green: 0.2, blue: 0.35)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [
            Color(red: 0.2, green: 0.6, blue: 0.9),
            Color(red: 0.3, green: 0.7, blue: 1.0)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}
