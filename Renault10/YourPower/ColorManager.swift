import SwiftUI

struct ColorManager {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let softPink = Color(red: 1.0, green: 0.9, blue: 0.9)
    static let lightBlue = Color(red: 0.9, green: 0.95, blue: 1.0)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.98, green: 0.98, blue: 1.0),
            Color(red: 0.95, green: 0.97, blue: 0.99),
            Color(red: 0.97, green: 0.95, blue: 0.98)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            backgroundWhite,
            Color(red: 0.98, green: 0.99, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [
            primaryBlue,
            Color(red: 0.1, green: 0.5, blue: 0.9)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let yellowButtonGradient = LinearGradient(
        gradient: Gradient(colors: [
            primaryYellow,
            Color(red: 0.9, green: 0.7, blue: 0.0)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
