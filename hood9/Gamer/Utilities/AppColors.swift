import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.86)
    static let secondaryBlue = Color(red: 0.1, green: 0.4, blue: 0.7)
    static let lightBlue = Color(red: 0.53, green: 0.81, blue: 0.92)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    
    static let background = Color.white
    static let cardBackground = Color.white.opacity(0.9)
    
    static let primaryText = Color(red: 0.1, green: 0.3, blue: 0.5)
    static let secondaryText = Color(red: 0.4, green: 0.5, blue: 0.6)
    static let lightText = Color.white
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let backgroundGradient = LinearGradient(
        colors: [Color.white, Color(red: 0.95, green: 0.97, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

