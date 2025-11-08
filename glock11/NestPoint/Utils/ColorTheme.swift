import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let blueText = primaryBlue
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundWhite, lightBlue.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundWhite, lightBlue.opacity(0.1)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
