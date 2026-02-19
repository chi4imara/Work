import SwiftUI

struct ColorManager {
    static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    static let tertiaryBackground = Color(red: 0.2, green: 0.25, blue: 0.4)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let placeholderText = Color.white.opacity(0.6)
    
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let lightOrange = Color(red: 1.0, green: 0.7, blue: 0.3)
    
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBackground, secondaryBackground]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        gradient: Gradient(colors: [secondaryBackground, tertiaryBackground]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [lightBlue, orange]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
