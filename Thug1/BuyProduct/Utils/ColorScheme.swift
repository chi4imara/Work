import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let primaryWhite = Color.white
    
    static let statusNormal = Color.green
    static let statusWarning = Color.orange
    static let statusDanger = Color.red
    
    static let backgroundPrimary = LinearGradient(
        gradient: Gradient(colors: [primaryBlue, lightBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
}
