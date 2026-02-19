import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let background = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.15, green: 0.2, blue: 0.35),
            Color(red: 0.1, green: 0.15, blue: 0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let buttonBackground = Color.white.opacity(0.15)
    
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    
    static let purple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let teal = Color(red: 0.2, green: 0.8, blue: 0.7)
}
