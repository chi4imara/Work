import SwiftUI

struct ColorScheme {
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let white = Color.white
    
    static let softGreen = Color(red: 0.18, green: 0.69, blue: 0.92)
    static let warmYellow = Color(red: 1.0, green: 0.9, blue: 0.4)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let mediumGray = Color.black
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [darkBlue, darkBlue.opacity(0.8), lightBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [lightBlue, lightBlue, white],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryText = darkBlue
    static let secondaryText = mediumGray
    static let lightText = white
    
    static let accent = softGreen
    static let warning = warmYellow
    static let error = Color.red.opacity(0.8)
    static let success = softGreen
}

struct DesignConstants {
    static let cornerRadius: CGFloat = 12
    static let smallCornerRadius: CGFloat = 8
    static let largeCornerRadius: CGFloat = 20
    
    static let smallPadding: CGFloat = 8
    static let mediumPadding: CGFloat = 16
    static let largePadding: CGFloat = 24
    
    static let shadowRadius: CGFloat = 8
    static let shadowOpacity: Double = 0.1
    
    static let animationDuration: Double = 0.3
    static let longAnimationDuration: Double = 0.6
}

