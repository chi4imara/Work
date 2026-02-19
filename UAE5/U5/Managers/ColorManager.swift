import SwiftUI

struct ColorManager {
    static let primaryBackground = Color(red: 0.08, green: 0.12, blue: 0.25)
    static let secondaryBackground = Color(red: 0.12, green: 0.18, blue: 0.32)
    static let tertiaryBackground = Color(red: 0.16, green: 0.22, blue: 0.38) 
    
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.1)
    static let accentPurple = Color(red: 0.6, green: 0.3, blue: 1.0)
    static let accentTeal = Color(red: 0.0, green: 0.8, blue: 0.7)
    
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.8, green: 0.8, blue: 0.85)
    static let tertiaryText = Color(red: 0.6, green: 0.6, blue: 0.7)
    static let mutedText = Color(red: 0.5, green: 0.5, blue: 0.6)
    
    static let cardBackground = Color(red: 0.18, green: 0.24, blue: 0.4)
    static let buttonBackground = Color(red: 0.2, green: 0.3, blue: 0.5)
    static let inputBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let errorRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let infoBlue = Color(red: 0.3, green: 0.7, blue: 1.0)
    
    static let lightGray = Color(red: 0.7, green: 0.7, blue: 0.75)
    static let mediumGray = Color(red: 0.5, green: 0.5, blue: 0.55)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.35)
    
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBackground, secondaryBackground, tertiaryBackground]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [cardBackground, cardBackground.opacity(0.7)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [accentBlue, accentOrange]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let purpleGradient = LinearGradient(
        gradient: Gradient(colors: [accentPurple, accentBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tealGradient = LinearGradient(
        gradient: Gradient(colors: [accentTeal, accentBlue]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let radialGradient = RadialGradient(
        gradient: Gradient(colors: [
            primaryBackground.opacity(0.8),
            secondaryBackground,
            tertiaryBackground
        ]),
        center: .center,
        startRadius: 50,
        endRadius: 400
    )
    
    static let angularGradient = AngularGradient(
        gradient: Gradient(colors: [
            accentBlue,
            accentPurple,
            accentOrange,
            accentTeal,
            accentBlue
        ]),
        center: .center
    )
}
