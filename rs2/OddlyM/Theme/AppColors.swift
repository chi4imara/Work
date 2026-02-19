import SwiftUI

struct AppColors {
    static let backgroundBlue = Color(red: 0.4, green: 0.7, blue: 0.9)
    static let backgroundBlueLight = Color(red: 0.5, green: 0.8, blue: 1.0)
    static let backgroundBlueDark = Color(red: 0.3, green: 0.6, blue: 0.8)
    
    static let textWhite = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let accentPurpleLight = Color(red: 0.7, green: 0.5, blue: 0.9)
    static let accentPurpleDark = Color(red: 0.5, green: 0.3, blue: 0.7)
    
    static let cardBackground = Color.white.opacity(0.2)
    static let buttonBackground = Color.white.opacity(0.3)
    static let borderColor = Color.white.opacity(0.4)
    
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundBlue, backgroundBlueLight, backgroundBlueDark],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
