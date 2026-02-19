import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let softYellow = Color(red: 1.0, green: 0.95, blue: 0.7)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    
    static let primaryText = primaryBlue
    static let secondaryText = Color.gray
    static let lightText = Color.white
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue.opacity(0.1)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryYellow, softYellow],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension ColorTheme {
    static func updatePrimaryColors(blue: Color, yellow: Color) {
    }
}
