import SwiftUI

struct ColorManager {
    static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let buttonBackground = Color.white.opacity(0.15)
    static let separatorColor = Color.white.opacity(0.2)
    
    static let primaryGradient = LinearGradient(
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
    
    static let categoryColors: [String: Color] = [
        "Home": Color(red: 0.3, green: 0.7, blue: 0.3),
        "Garage": Color(red: 0.7, green: 0.3, blue: 0.3),
        "Garden": Color(red: 0.3, green: 0.6, blue: 0.7),
        "Repair": accentOrange,
        "Other": Color.gray
    ]
}
