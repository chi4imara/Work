import SwiftUI

struct AppColors {
    static let primaryOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let primaryNavy = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let primaryWhite = Color.white
    
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let softGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let mediumGray = Color(red: 0.7, green: 0.7, blue: 0.7)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.98, green: 0.98, blue: 1.0),
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.92, green: 0.95, blue: 0.98)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            primaryWhite.opacity(0.9),
            primaryWhite.opacity(0.7)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryText = primaryNavy
    static let secondaryText = darkGray
    static let accentText = primaryOrange
}
