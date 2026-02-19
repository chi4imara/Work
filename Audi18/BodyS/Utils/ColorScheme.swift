import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let softGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let lightPink = Color(red: 1.0, green: 0.9, blue: 0.95)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color(red: 0.95, green: 0.97, blue: 0.99),
            Color(red: 0.92, green: 0.95, blue: 0.98)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.9),
            Color(red: 0.98, green: 0.99, blue: 1.0).opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
