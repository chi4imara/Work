import SwiftUI

struct AppColors {
    static let backgroundGradientStart = Color(red: 0.95, green: 0.97, blue: 1.0)
    static let backgroundGradientEnd = Color(red: 0.85, green: 0.92, blue: 0.98)
    
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.7, green: 0.85, blue: 0.95)
    
    static let primaryText = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let secondaryText = Color(red: 0.4, green: 0.5, blue: 0.7)
    static let lightText = Color.white
    
    static let ideaColor = Color.gray
    static let boughtColor = Color.green
    static let giftedColor = Color.blue
    
    static let cardBackground = Color.white.opacity(0.9)
    static let cardShadow = Color.black.opacity(0.1)
    
    static let accentOrange = Color.orange
    static let accentPurple = Color.purple
    static let accentPink = Color.pink
    
    static let errorRed = Color.red
    static let successGreen = Color.green
    static let warningYellow = Color.yellow
}

extension Color {
    static let theme = AppColors.self
}
