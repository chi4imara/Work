import SwiftUI

extension Color {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let primaryOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let mediumGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let lightBlue = Color(red: 0.4, green: 0.6, blue: 0.9)
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.darkBlue,
            Color(red: 0.15, green: 0.2, blue: 0.4),
            Color(red: 0.2, green: 0.25, blue: 0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
