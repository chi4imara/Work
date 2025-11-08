import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.5)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.3, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [Color.primaryBlue, Color.darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.9), Color.lightBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [Color.lightBlue, Color.primaryBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let cardText = Color.black.opacity(0.8)
    static let cardSecondaryText = Color.black.opacity(0.6)
}
