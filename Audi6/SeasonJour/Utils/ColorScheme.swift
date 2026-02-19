import SwiftUI

struct AppColors {
    static let background = Color.white
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let contrastText = Color.white
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.98, green: 0.98, blue: 1.0),
            Color(red: 0.95, green: 0.97, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.99, green: 0.99, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
