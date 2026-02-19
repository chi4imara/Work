import SwiftUI

struct ColorManager {
    static let primaryPink = Color(red: 0.96, green: 0.64, blue: 0.85)
    static let accentYellow = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let textWhite = Color(red: 0.25, green: 0.25, blue: 0.25)
    static let textBlack = Color.black
    static let cardWhite = Color.white
    
    static let lightPink = Color(red: 0.98, green: 0.82, blue: 0.93)
    static let darkPink = Color(red: 0.85, green: 0.45, blue: 0.75)
    static let softYellow = Color(red: 1.0, green: 0.92, blue: 0.6)
    static let orange = Color(red: 1.0, green: 0.65, blue: 0.0)
    
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    static let infoBlue = Color(red: 0.3, green: 0.6, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [primaryPink, lightPink, darkPink]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [cardWhite.opacity(0.9), cardWhite.opacity(0.7)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [accentYellow, softYellow]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let theme = ColorManager.self
}
