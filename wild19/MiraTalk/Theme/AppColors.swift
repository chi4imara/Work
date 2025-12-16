import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let blueGradientStart = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let blueGradientEnd = Color(red: 0.1, green: 0.4, blue: 0.8)
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryWhite, blueGradientStart.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [primaryWhite, lightGray],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let primaryText = primaryBlue
    static let secondaryText = darkGray
    static let accentText = primaryYellow
}
