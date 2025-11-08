import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let backgroundBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let yellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let green = Color(red: 0.0, green: 0.8, blue: 0.4)
    static let red = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let gridWhite = Color.white.opacity(0.1)
    
    static let purple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let teal = Color(red: 0.2, green: 0.8, blue: 0.8)
}

extension AppColors {
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                backgroundBlue,
                primaryBlue,
                backgroundBlue.opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
