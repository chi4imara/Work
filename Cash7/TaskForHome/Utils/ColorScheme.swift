import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let pureWhite = Color.white
    
    static let softGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let mediumGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let successGreen = Color(red: 0.1, green: 0.9, blue: 0.3)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let dangerRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBlue, lightBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradientStatistics = LinearGradient(
        gradient: Gradient(colors: [
            primaryBlue.opacity(0.8),
            lightBlue.opacity(0.7),
            .white.opacity(0.3)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [pureWhite, softGray]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [lightBlue, primaryBlue]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

